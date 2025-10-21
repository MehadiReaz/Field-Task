import 'package:injectable/injectable.dart';
import '../../../../database/database.dart';
import '../models/task_stats_model.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/enums/task_status.dart';

abstract class TaskStatsLocalDataSource {
  Future<TaskStatsModel?> getTaskStats(String userId);
  Future<TaskStatsModel> calculateAndSaveStats(String userId);
  Future<void> updateTaskStats(TaskStatsModel stats);
}

@Injectable(as: TaskStatsLocalDataSource)
class TaskStatsLocalDataSourceImpl implements TaskStatsLocalDataSource {
  final AppDatabase database;

  TaskStatsLocalDataSourceImpl({required this.database});

  @override
  Future<TaskStatsModel?> getTaskStats(String userId) async {
    try {
      // For now, calculate fresh stats each time
      // In production, you could cache this
      return null;
    } catch (e) {
      AppLogger.error('Failed to get local task stats: $e');
      return null;
    }
  }

  @override
  Future<TaskStatsModel> calculateAndSaveStats(String userId) async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Fetch all user's tasks from local database
      final tasks = await database.taskDao.getTasksPaginated(
        userId: userId,
        limit: 100000,
        offset: 0,
      );

      // Calculate statistics
      int totalTasks = tasks.length;
      int pendingTasks = 0;
      int completedTasks = 0;
      int checkedInTasks = 0;
      int expiredTasks = 0;
      int dueTodayTasks = 0;

      for (final task in tasks) {
        // Count by status
        if (task.status == TaskStatus.pending.value) {
          pendingTasks++;
        } else if (task.status == TaskStatus.completed.value) {
          completedTasks++;
        } else if (task.status == TaskStatus.checkedIn.value) {
          checkedInTasks++;
        }

        // Count expired (past due and not completed)
        if (task.dueDateTime.isBefore(now) &&
            task.status != TaskStatus.completed.value &&
            task.status != TaskStatus.checkedOut.value) {
          expiredTasks++;
        }

        // Count due today
        if (task.dueDateTime.isAfter(todayStart) &&
            task.dueDateTime.isBefore(todayEnd)) {
          dueTodayTasks++;
        }
      }

      // Create stats model
      final stats = TaskStatsModel(
        id: 'local_stats_$userId',
        userId: userId,
        totalTasks: totalTasks,
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        checkedInTasks: checkedInTasks,
        expiredTasks: expiredTasks,
        dueTodayTasks: dueTodayTasks,
        updatedAt: DateTime.now(),
      );

      // Save to local database
      await updateTaskStats(stats);

      AppLogger.info(
          'Local task stats calculated: Total: $totalTasks, Pending: $pendingTasks, '
          'Completed: $completedTasks, Checked In: $checkedInTasks, '
          'Expired: $expiredTasks, Due Today: $dueTodayTasks');

      return stats;
    } catch (e) {
      AppLogger.error('Failed to calculate local task stats: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateTaskStats(TaskStatsModel stats) async {
    try {
      // For now, we'll just log this since we're calculating on the fly
      // In production, you could cache this in a table
      AppLogger.info('Task stats updated locally');
    } catch (e) {
      AppLogger.error('Failed to update local task stats: $e');
    }
  }
}
