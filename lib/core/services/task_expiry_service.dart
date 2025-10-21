import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../utils/logger.dart';
import '../../core/enums/task_status.dart';
import 'dashboard_service.dart';

/// Service to automatically check and update expired tasks
/// 
/// This service checks tasks on each load to see if they have passed
/// their due date. If a task is expired and not completed/cancelled,
/// it updates the task status to 'expired' and updates dashboard counts.
@lazySingleton
class TaskExpiryService {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final DashboardService dashboardService;

  TaskExpiryService({
    required this.firestore,
    required this.firebaseAuth,
    required this.dashboardService,
  });

  String get _currentUserId {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  /// Check all user's tasks and update expired ones
  /// Returns the number of tasks that were marked as expired
  Future<int> checkAndUpdateExpiredTasks() async {
    try {
      AppLogger.info('Checking for expired tasks...');
      final userId = _currentUserId;
      final now = DateTime.now();

      // Query all active tasks (pending and checked in) for this user
      final assignedQuery = await firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'checked_in'])
          .get();

      final createdQuery = await firestore
          .collection('tasks')
          .where('createdBy', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'checked_in'])
          .get();

      // Merge tasks (avoid duplicates)
      final tasksMap = <String, QueryDocumentSnapshot>{};
      for (final doc in assignedQuery.docs) {
        tasksMap[doc.id] = doc;
      }
      for (final doc in createdQuery.docs) {
        tasksMap[doc.id] = doc;
      }

      int expiredCount = 0;

      // Check each task for expiry
      final batch = firestore.batch();
      
      for (final doc in tasksMap.values) {
        final data = doc.data() as Map<String, dynamic>;
        final dueDateStr = data['dueDate'] as String?;
        final statusValue = data['status'] as String?;

        if (dueDateStr == null || statusValue == null) continue;

        try {
          final dueDate = DateTime.parse(dueDateStr);
          final status = TaskStatus.fromString(statusValue);

          // Check if task is expired
          if (dueDate.isBefore(now) && 
              (status == TaskStatus.pending || status == TaskStatus.checkedIn)) {
            
            // Update task status to 'expired' and add metadata
            batch.update(doc.reference, {
              'status': 'expired',  // UPDATE THE STATUS FIELD
              'metadata.isExpired': true,
              'metadata.expiredAt': now.toIso8601String(),
              'updatedAt': now.toIso8601String(),
            });

            // Update dashboard counts: move from old status to expired
            await dashboardService.updateStatusCounts(
              oldStatus: status,
              newStatus: TaskStatus.expired, // Status changes to expired
              wasExpired: false,
              isExpired: true,
            );

            expiredCount++;
            AppLogger.warning('Marked task as expired: ${doc.id} (was ${status.value})');
          }
        } catch (e) {
          AppLogger.error('Error processing task ${doc.id}: $e');
        }
      }

      // Commit all updates
      if (expiredCount > 0) {
        await batch.commit();
        AppLogger.info('Updated $expiredCount expired task(s)');
      } else {
        AppLogger.info('No expired tasks found');
      }

      return expiredCount;
    } catch (e) {
      AppLogger.error('Failed to check expired tasks: $e');
      return 0;
    }
  }

  /// Check if a single task is expired
  bool isTaskExpired(DateTime dueDate, TaskStatus status) {
    final now = DateTime.now();
    return dueDate.isBefore(now) && 
           status != TaskStatus.completed &&
           status != TaskStatus.cancelled &&
           status != TaskStatus.expired; // Don't re-expire already expired tasks
  }

  /// Update a task's expiry status if needed
  /// Call this when loading individual tasks
  Future<void> checkAndUpdateSingleTask(String taskId) async {
    try {
      final doc = await firestore.collection('tasks').doc(taskId).get();
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      final dueDateStr = data['dueDate'] as String?;
      final statusValue = data['status'] as String?;
      final isExpired = (data['metadata']?['isExpired'] as bool?) ?? false;

      if (dueDateStr == null || statusValue == null) return;

      final dueDate = DateTime.parse(dueDateStr);
      final status = TaskStatus.fromString(statusValue);
      final shouldBeExpired = isTaskExpired(dueDate, status);

      // If expiry status changed, update it
      if (shouldBeExpired && !isExpired && status != TaskStatus.expired) {
        final now = DateTime.now();
        await doc.reference.update({
          'status': 'expired',  // UPDATE THE STATUS FIELD
          'metadata.isExpired': true,
          'metadata.expiredAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        });

        // Update dashboard
        await dashboardService.updateStatusCounts(
          oldStatus: status,
          newStatus: TaskStatus.expired,
          wasExpired: false,
          isExpired: true,
        );

        AppLogger.info('Marked single task as expired: $taskId');
      } else if (!shouldBeExpired && isExpired && status == TaskStatus.expired) {
        // Task was expired but no longer is (due date changed?)
        // Restore to pending status
        await doc.reference.update({
          'status': 'pending',
          'metadata.isExpired': false,
          'metadata.expiredAt': null,
          'updatedAt': DateTime.now().toIso8601String(),
        });

        // Update dashboard
        await dashboardService.updateStatusCounts(
          oldStatus: TaskStatus.expired,
          newStatus: TaskStatus.pending,
          wasExpired: true,
          isExpired: false,
        );

        AppLogger.info('Restored task from expired to pending: $taskId');
      }
    } catch (e) {
      AppLogger.error('Failed to check single task expiry: $e');
    }
  }

  /// Get count of expired tasks (for display purposes)
  Future<int> getExpiredTasksCount() async {
    try {
      final userId = _currentUserId;

      // Query by status = 'expired' for accurate count
      final assignedQuery = await firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: userId)
          .where('status', isEqualTo: 'expired')
          .get();

      final createdQuery = await firestore
          .collection('tasks')
          .where('createdBy', isEqualTo: userId)
          .where('status', isEqualTo: 'expired')
          .get();

      // Count unique tasks
      final taskIds = <String>{};
      taskIds.addAll(assignedQuery.docs.map((doc) => doc.id));
      taskIds.addAll(createdQuery.docs.map((doc) => doc.id));

      return taskIds.length;
    } catch (e) {
      AppLogger.error('Failed to get expired tasks count: $e');
      return 0;
    }
  }
}