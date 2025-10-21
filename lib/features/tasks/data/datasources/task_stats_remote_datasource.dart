import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../models/task_stats_model.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/utils/logger.dart';

abstract class TaskStatsRemoteDataSource {
  Future<TaskStatsModel> getTaskStats();
  Future<TaskStatsModel> calculateAndSaveStats();
}

@Injectable(as: TaskStatsRemoteDataSource)
class TaskStatsRemoteDataSourceImpl implements TaskStatsRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  TaskStatsRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  String get _currentUserId {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  @override
  Future<TaskStatsModel> getTaskStats() async {
    try {
      final userId = _currentUserId;

      // Try to get cached stats first
      final statsDoc = await firestore
          .collection('users')
          .doc(userId)
          .collection('stats')
          .doc('tasks')
          .get();

      if (statsDoc.exists) {
        return TaskStatsModel.fromFirestore({
          ...statsDoc.data() as Map<String, dynamic>,
          'id': statsDoc.id,
        });
      }

      // If not found, calculate fresh stats
      return await calculateAndSaveStats();
    } catch (e) {
      AppLogger.error('Failed to get task stats: $e');
      rethrow;
    }
  }

  @override
  Future<TaskStatsModel> calculateAndSaveStats() async {
    try {
      final userId = _currentUserId;
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Fetch all user's tasks
      final tasksSnapshot = await firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: userId)
          .get();

      final tasks = tasksSnapshot.docs;

      // Calculate statistics
      int totalTasks = tasks.length;
      int pendingTasks = 0;
      int completedTasks = 0;
      int checkedInTasks = 0;
      int expiredTasks = 0;
      int dueTodayTasks = 0;

      for (final taskDoc in tasks) {
        final taskData = taskDoc.data();
        final status = taskData['status'] as String?;
        final dueDate = taskData['dueDate'] != null
            ? DateTime.parse(taskData['dueDate'] as String)
            : null;

        // Count by status
        if (status == TaskStatus.pending.value) {
          pendingTasks++;
        } else if (status == TaskStatus.completed.value) {
          completedTasks++;
        } else if (status == TaskStatus.checkedIn.value) {
          checkedInTasks++;
        }

        // Count expired (past due and not completed)
        if (dueDate != null &&
            dueDate.isBefore(now) &&
            status != TaskStatus.completed.value &&
            status != TaskStatus.checkedOut.value) {
          expiredTasks++;
        }

        // Count due today
        if (dueDate != null &&
            dueDate.isAfter(todayStart) &&
            dueDate.isBefore(todayEnd)) {
          dueTodayTasks++;
        }
      }

      // Create stats model
      final stats = TaskStatsModel(
        id: 'tasks',
        userId: userId,
        totalTasks: totalTasks,
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        checkedInTasks: checkedInTasks,
        expiredTasks: expiredTasks,
        dueTodayTasks: dueTodayTasks,
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await firestore
          .collection('users')
          .doc(userId)
          .collection('stats')
          .doc('tasks')
          .set(stats.toFirestore());

      AppLogger.info(
          'Task stats calculated: Total: $totalTasks, Pending: $pendingTasks, '
          'Completed: $completedTasks, Checked In: $checkedInTasks, '
          'Expired: $expiredTasks, Due Today: $dueTodayTasks');

      return stats;
    } catch (e) {
      AppLogger.error('Failed to calculate task stats: $e');
      rethrow;
    }
  }
}
