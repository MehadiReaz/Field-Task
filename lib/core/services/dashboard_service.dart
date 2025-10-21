import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../utils/logger.dart';
import '../../core/enums/task_status.dart';

/// Service to manage dashboard statistics in Firebase
/// 
/// This service maintains a `dashboard` collection in Firestore that tracks
/// task counts by status for each user. The counts are updated automatically
/// whenever tasks are created, updated, or deleted.
@lazySingleton
class DashboardService {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  DashboardService({
    required this.firestore,
    required this.firebaseAuth,
  });

  String get _currentUserId {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  /// Get the dashboard document reference for current user
  DocumentReference get _dashboardRef =>
      firestore.collection('dashboard').doc(_currentUserId);

  /// Initialize dashboard with zero counts (call on first login)
  Future<void> initializeDashboard() async {
    try {
      final doc = await _dashboardRef.get();
      if (!doc.exists) {
        await _dashboardRef.set({
          'userId': _currentUserId,
          'total': 0,
          'pending': 0,
          'checkedIn': 0,
          'completed': 0,
          'expired': 0,
          'cancelled': 0,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        AppLogger.info('Dashboard initialized for user: $_currentUserId');
      }
    } catch (e) {
      AppLogger.error('Failed to initialize dashboard: $e');
    }
  }

  /// Recalculate all counts from scratch by querying tasks
  Future<void> recalculateAllCounts() async {
    try {
      final userId = _currentUserId;
      final now = DateTime.now();

      // Query all tasks for this user
      final assignedQuery = await firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: userId)
          .get();

      final createdQuery = await firestore
          .collection('tasks')
          .where('createdBy', isEqualTo: userId)
          .get();

      // Merge tasks (avoid duplicates)
      final tasksMap = <String, Map<String, dynamic>>{};
      for (final doc in assignedQuery.docs) {
        tasksMap[doc.id] = doc.data();
      }
      for (final doc in createdQuery.docs) {
        tasksMap[doc.id] = doc.data();
      }

      // Count by status
      int total = 0;
      int pending = 0;
      int checkedIn = 0;
      int completed = 0;
      int expired = 0;
      int cancelled = 0;

      for (final taskData in tasksMap.values) {
        final statusValue = taskData['status'] as String?;
        final dueDateStr = taskData['dueDate'] as String?;
        
        if (statusValue == null) continue;

        final status = TaskStatus.fromString(statusValue);
        
        // Check if task is expired (due date passed and not completed)
        bool isExpired = false;
        if (dueDateStr != null) {
          try {
            final dueDate = DateTime.parse(dueDateStr);
            isExpired = dueDate.isBefore(now) && 
                       status != TaskStatus.completed &&
                       status != TaskStatus.cancelled;
          } catch (_) {}
        }

        total++;

        if (isExpired) {
          expired++;
        } else {
          switch (status) {
            case TaskStatus.pending:
              pending++;
              break;
            case TaskStatus.checkedIn:
              checkedIn++;
              break;
            case TaskStatus.completed:
              completed++;
              break;
            case TaskStatus.cancelled:
              cancelled++;
              break;
            case TaskStatus.expired:
              expired++;
              break;
            case TaskStatus.checkedOut:
              // Don't count checked out tasks
              break;
          }
        }
      }

      // Update dashboard
      await _dashboardRef.set({
        'userId': userId,
        'total': total,
        'pending': pending,
        'checkedIn': checkedIn,
        'completed': completed,
        'expired': expired,
        'cancelled': cancelled,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Dashboard recalculated: total=$total, pending=$pending, '
          'checkedIn=$checkedIn, completed=$completed, expired=$expired, cancelled=$cancelled');
    } catch (e) {
      AppLogger.error('Failed to recalculate dashboard: $e');
      rethrow;
    }
  }

  /// Increment a specific status count
  Future<void> incrementCount(TaskStatus status, {bool isExpired = false}) async {
    try {
      final updates = <String, dynamic>{
        'total': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (isExpired) {
        updates['expired'] = FieldValue.increment(1);
      } else {
        final field = _getStatusField(status);
        if (field != null) {
          updates[field] = FieldValue.increment(1);
        }
      }

      await _dashboardRef.update(updates);
      AppLogger.debug('Incremented count for ${isExpired ? 'expired' : status.value}');
    } catch (e) {
      AppLogger.error('Failed to increment count: $e');
      // Initialize if dashboard doesn't exist
      await initializeDashboard();
      await recalculateAllCounts();
    }
  }

  /// Decrement a specific status count
  Future<void> decrementCount(TaskStatus status, {bool isExpired = false}) async {
    try {
      final updates = <String, dynamic>{
        'total': FieldValue.increment(-1),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (isExpired) {
        updates['expired'] = FieldValue.increment(-1);
      } else {
        final field = _getStatusField(status);
        if (field != null) {
          updates[field] = FieldValue.increment(-1);
        }
      }

      await _dashboardRef.update(updates);
      AppLogger.debug('Decremented count for ${isExpired ? 'expired' : status.value}');
    } catch (e) {
      AppLogger.error('Failed to decrement count: $e');
    }
  }

  /// Update counts when task status changes (e.g., pending → completed)
  /// This decrements the old status and increments the new status
  Future<void> updateStatusCounts({
    required TaskStatus oldStatus,
    required TaskStatus newStatus,
    bool wasExpired = false,
    bool isExpired = false,
  }) async {
    try {
      final updates = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Decrement old status
      if (wasExpired) {
        updates['expired'] = FieldValue.increment(-1);
      } else {
        final oldField = _getStatusField(oldStatus);
        if (oldField != null) {
          updates[oldField] = FieldValue.increment(-1);
        }
      }

      // Increment new status
      if (isExpired) {
        updates['expired'] = FieldValue.increment(1);
      } else {
        final newField = _getStatusField(newStatus);
        if (newField != null) {
          updates[newField] = FieldValue.increment(1);
        }
      }

      await _dashboardRef.update(updates);
      AppLogger.info('Updated counts: ${wasExpired ? 'expired' : oldStatus.value} → ${isExpired ? 'expired' : newStatus.value}');
    } catch (e) {
      AppLogger.error('Failed to update status counts: $e');
      // Fallback: recalculate everything
      await recalculateAllCounts();
    }
  }

  /// Get dashboard counts as a stream
  Stream<Map<String, int>> watchDashboard() {
    return _dashboardRef.snapshots().map((doc) {
      if (!doc.exists) {
        return {
          'total': 0,
          'pending': 0,
          'checkedIn': 0,
          'completed': 0,
          'expired': 0,
          'cancelled': 0,
        };
      }

      final data = doc.data() as Map<String, dynamic>;
      return {
        'total': (data['total'] as int?) ?? 0,
        'pending': (data['pending'] as int?) ?? 0,
        'checkedIn': (data['checkedIn'] as int?) ?? 0,
        'completed': (data['completed'] as int?) ?? 0,
        'expired': (data['expired'] as int?) ?? 0,
        'cancelled': (data['cancelled'] as int?) ?? 0,
      };
    });
  }

  /// Get dashboard counts once
  Future<Map<String, int>> getDashboard() async {
    try {
      final doc = await _dashboardRef.get();
      if (!doc.exists) {
        await initializeDashboard();
        await recalculateAllCounts();
        return getDashboard();
      }

      final data = doc.data() as Map<String, dynamic>;
      return {
        'total': (data['total'] as int?) ?? 0,
        'pending': (data['pending'] as int?) ?? 0,
        'checkedIn': (data['checkedIn'] as int?) ?? 0,
        'completed': (data['completed'] as int?) ?? 0,
        'expired': (data['expired'] as int?) ?? 0,
        'cancelled': (data['cancelled'] as int?) ?? 0,
      };
    } catch (e) {
      AppLogger.error('Failed to get dashboard: $e');
      return {
        'total': 0,
        'pending': 0,
        'checkedIn': 0,
        'completed': 0,
        'expired': 0,
        'cancelled': 0,
      };
    }
  }

  /// Helper to get field name for status
  String? _getStatusField(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.checkedIn:
        return 'checkedIn';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.cancelled:
        return 'cancelled';
      case TaskStatus.expired:
        return 'expired';
      case TaskStatus.checkedOut:
        return null; // Don't count checked out
    }
  }
}
