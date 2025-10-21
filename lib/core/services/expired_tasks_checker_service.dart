import 'package:injectable/injectable.dart';
import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../utils/logger.dart';
import 'local_notification_service.dart';

@lazySingleton
class ExpiredTasksCheckerService {
  final TaskRepository taskRepository;
  final LocalNotificationService notificationService;

  ExpiredTasksCheckerService({
    required this.taskRepository,
    required this.notificationService,
  });

  /// Check for expired tasks and show notification if any
  Future<void> checkAndNotifyExpiredTasks() async {
    try {
      AppLogger.info('Checking for expired tasks...');

      // Get expired tasks from repository
      final result = await taskRepository.getExpiredTasks();

      result.fold(
        (failure) {
          AppLogger.error('Failed to fetch expired tasks: ${failure.message}');
        },
        (expiredTasks) async {
          if (expiredTasks.isEmpty) {
            AppLogger.info('No expired tasks found');
            return;
          }

          AppLogger.warning('Found ${expiredTasks.length} expired task(s)');

          // Show notification
          await _showExpiredNotification(expiredTasks);
        },
      );
    } catch (e) {
      AppLogger.error('Error checking expired tasks: $e');
    }
  }

  /// Show notification for expired tasks
  Future<void> _showExpiredNotification(List<Task> expiredTasks) async {
    if (expiredTasks.isEmpty) return;

    try {
      // If only one expired task, show its title
      if (expiredTasks.length == 1) {
        await notificationService.showExpiredTasksNotification(
          expiredCount: 1,
          taskTitle: expiredTasks.first.title,
        );
      } else {
        // Multiple expired tasks
        await notificationService.showExpiredTasksNotification(
          expiredCount: expiredTasks.length,
        );
      }
    } catch (e) {
      AppLogger.error('Failed to show expired tasks notification: $e');
    }
  }

  /// Get count of expired tasks (for badge display)
  Future<int> getExpiredTasksCount() async {
    try {
      final result = await taskRepository.getExpiredTasks();
      return result.fold(
        (failure) => 0,
        (tasks) => tasks.length,
      );
    } catch (e) {
      AppLogger.error('Error getting expired tasks count: $e');
      return 0;
    }
  }

  /// Check if there are any expired tasks (quick check)
  Future<bool> hasExpiredTasks() async {
    final count = await getExpiredTasksCount();
    return count > 0;
  }
}
