import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/enums/task_status.dart';
import '../models/task_model.dart';
import '../models/task_page_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskPageModel> getTasksPage({
    DocumentSnapshot? lastDocument,
    int pageSize = 4,
    String? status,
    bool showExpiredOnly = false,
  });
  Future<List<TaskModel>> getTasksByStatus(String status);
  Future<List<TaskModel>> getExpiredTasks();
  Future<List<TaskModel>> searchTasks({
    required String query,
    List<String> searchFields = const ['title', 'description'],
  });
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<TaskModel> checkInTask(
    String id,
    double latitude,
    double longitude,
    String? photoUrl,
  );
  Future<TaskModel> checkoutTask(String id);
  Future<TaskModel> completeTask(
    String id,
    String? completionNotes,
    String? photoUrl,
  );
  Stream<List<TaskModel>> watchTasks();
  Stream<TaskModel?> watchTaskById(String id);
}

@LazySingleton(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  TaskRemoteDataSourceImpl(this.firestore, this.firebaseAuth);

  String get _currentUserId {
    final user = firebaseAuth.currentUser;
    if (user == null) throw const FirestoreException('User not authenticated');
    return user.uid;
  }

  Future<List<TaskModel>> _fetchAndDeduplicateTasks({
    List<String>? statusFilter,
  }) async {
    final userId = _currentUserId;

    var assignedQuery =
        firestore.collection('tasks').where('assignedTo', isEqualTo: userId);

    var createdQuery =
        firestore.collection('tasks').where('createdBy', isEqualTo: userId);

    if (statusFilter != null) {
      assignedQuery = assignedQuery.where('status', whereIn: statusFilter);
      createdQuery = createdQuery.where('status', whereIn: statusFilter);
    }

    final results = await Future.wait([
      assignedQuery.get(),
      createdQuery.get(),
    ]);

    final tasksMap = <String, TaskModel>{};

    for (final snapshot in results) {
      for (final doc in snapshot.docs) {
        final task = TaskModel.fromFirestore(doc.data());
        tasksMap[task.id] = task;
      }
    }

    return tasksMap.values.toList();
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      return await _fetchAndDeduplicateTasks(
        statusFilter: ['pending', 'checkedIn'],
      );
    } catch (e) {
      throw FirestoreException('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<TaskPageModel> getTasksPage({
    DocumentSnapshot? lastDocument,
    int pageSize = 4,
    String? status,
    bool showExpiredOnly = false,
  }) async {
    try {
      final allTasks = await _fetchAndDeduplicateTasks();

      // Apply filters
      List<TaskModel> filteredTasks = allTasks;

      if (showExpiredOnly ||
          (status != null && status.toLowerCase() == 'expired')) {
        final now = DateTime.now();
        filteredTasks = allTasks.where((task) {
          return task.dueDateTime.isBefore(now) &&
              task.status != TaskStatus.completed;
        }).toList();
      } else if (status != null && status.isNotEmpty) {
        filteredTasks = allTasks.where((task) {
          return task.status.value.toLowerCase() == status.toLowerCase();
        }).toList();
      } else {
        // Default: show all tasks (including completed)
        // This allows filter chips to show accurate counts
        filteredTasks = allTasks.where((task) {
          return task.status != TaskStatus.checkedOut &&
              task.status != TaskStatus.cancelled;
        }).toList();
      }

      // Sort by createdAt descending
      filteredTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Apply pagination
      int startIndex = 0;
      if (lastDocument != null) {
        final lastDocId = lastDocument.id;
        final foundIndex =
            filteredTasks.indexWhere((task) => task.id == lastDocId);
        if (foundIndex >= 0) {
          startIndex = foundIndex + 1;
        }
      }

      final endIndex = (startIndex + pageSize).clamp(0, filteredTasks.length);
      final pageTasks = filteredTasks.sublist(startIndex, endIndex);

      // Get last document for next page
      DocumentSnapshot? nextLastDocument;
      if (pageTasks.isNotEmpty && endIndex < filteredTasks.length) {
        final lastTaskId = pageTasks.last.id;
        final doc = await firestore.collection('tasks').doc(lastTaskId).get();
        if (doc.exists) {
          nextLastDocument = doc;
        }
      }

      return TaskPageModel(
        tasks: pageTasks,
        lastDocument: nextLastDocument,
        hasMore: endIndex < filteredTasks.length,
      );
    } catch (e) {
      throw FirestoreException('Failed to fetch paginated tasks: $e');
    }
  }

  @override
  Future<List<TaskModel>> searchTasks({
    required String query,
    List<String> searchFields = const ['title', 'description'],
  }) async {
    try {
      final allTasks = await _fetchAndDeduplicateTasks();
      final queryLower = query.toLowerCase();

      final filteredTasks = allTasks.where((task) {
        for (final field in searchFields) {
          final fieldValue = _getFieldValue(task, field);
          if (fieldValue != null &&
              fieldValue.toLowerCase().contains(queryLower)) {
            return true;
          }
        }
        return false;
      }).toList();

      filteredTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filteredTasks;
    } catch (e) {
      throw FirestoreException('Failed to search tasks: $e');
    }
  }

  String? _getFieldValue(TaskModel task, String field) {
    switch (field.toLowerCase()) {
      case 'title':
        return task.title;
      case 'description':
        return task.description;
      case 'address':
        return task.address;
      case 'assignedtoname':
        return task.assignedToName;
      case 'status':
        return task.status.value;
      default:
        return null;
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final doc = await firestore.collection('tasks').doc(id).get();
      if (!doc.exists) {
        throw const FirestoreException('Task not found');
      }
      return TaskModel.fromFirestore(doc.data()!);
    } catch (e) {
      throw FirestoreException('Failed to fetch task: $e');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final docRef = firestore.collection('tasks').doc();
      final now = DateTime.now();

      final taskWithId = TaskModel(
        id: docRef.id,
        title: task.title,
        description: task.description,
        dueDateTime: task.dueDateTime,
        status: task.status,
        priority: task.priority,
        latitude: task.latitude,
        longitude: task.longitude,
        address: task.address,
        assignedToId: task.assignedToId,
        assignedToName: task.assignedToName,
        createdById: task.createdById,
        createdByName: task.createdByName,
        createdAt: task.createdAt,
        updatedAt: now,
        checkedInAt: task.checkedInAt,
        completedAt: task.completedAt,
        photoUrls: task.photoUrls,
        checkInPhotoUrl: task.checkInPhotoUrl,
        completionPhotoUrl: task.completionPhotoUrl,
        syncStatus: task.syncStatus,
        completionNotes: task.completionNotes,
        metadata: task.metadata,
      );

      await docRef.set(taskWithId.toFirestore());
      return taskWithId;
    } catch (e) {
      throw FirestoreException('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final now = DateTime.now();
      await firestore.collection('tasks').doc(task.id).update(
            task.toFirestore()..['updatedAt'] = now.toIso8601String(),
          );
      return task;
    } catch (e) {
      throw FirestoreException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await firestore.collection('tasks').doc(id).delete();
    } catch (e) {
      throw FirestoreException('Failed to delete task: $e');
    }
  }

  @override
  Future<TaskModel> checkInTask(
    String id,
    double latitude,
    double longitude,
    String? photoUrl,
  ) async {
    try {
      final task = await getTaskById(id);
      final now = DateTime.now();

      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDateTime: task.dueDateTime,
        status: TaskStatus.checkedIn,
        priority: task.priority,
        latitude: latitude,
        longitude: longitude,
        address: task.address,
        assignedToId: task.assignedToId,
        assignedToName: task.assignedToName,
        createdById: task.createdById,
        createdByName: task.createdByName,
        createdAt: task.createdAt,
        updatedAt: now,
        checkedInAt: now,
        completedAt: task.completedAt,
        photoUrls: task.photoUrls,
        checkInPhotoUrl: photoUrl,
        completionPhotoUrl: task.completionPhotoUrl,
        syncStatus: task.syncStatus,
        completionNotes: task.completionNotes,
        metadata: task.metadata,
      );

      await firestore.collection('tasks').doc(id).update(
            updatedTask.toFirestore()
              ..['updatedAt'] = now.toIso8601String()
              ..['checkedInAt'] = now.toIso8601String(),
          );

      return updatedTask;
    } catch (e) {
      throw FirestoreException('Failed to check in task: $e');
    }
  }

  @override
  Future<TaskModel> checkoutTask(String id) async {
    try {
      final task = await getTaskById(id);
      final now = DateTime.now();

      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDateTime: task.dueDateTime,
        status: TaskStatus.checkedOut,
        priority: task.priority,
        latitude: task.latitude,
        longitude: task.longitude,
        address: task.address,
        assignedToId: task.assignedToId,
        assignedToName: task.assignedToName,
        createdById: task.createdById,
        createdByName: task.createdByName,
        createdAt: task.createdAt,
        updatedAt: now,
        checkedInAt: task.checkedInAt,
        checkedOutAt: now,
        completedAt: task.completedAt,
        photoUrls: task.photoUrls,
        checkInPhotoUrl: task.checkInPhotoUrl,
        completionPhotoUrl: task.completionPhotoUrl,
        syncStatus: task.syncStatus,
        completionNotes: task.completionNotes,
        metadata: task.metadata,
      );

      await firestore.collection('tasks').doc(id).update(
            updatedTask.toFirestore()
              ..['updatedAt'] = now.toIso8601String()
              ..['checkedOutAt'] = now.toIso8601String(),
          );

      return updatedTask;
    } catch (e) {
      throw FirestoreException('Failed to checkout task: $e');
    }
  }

  @override
  Future<TaskModel> completeTask(
    String id,
    String? completionNotes,
    String? photoUrl,
  ) async {
    try {
      final task = await getTaskById(id);
      final now = DateTime.now();

      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDateTime: task.dueDateTime,
        status: TaskStatus.completed,
        priority: task.priority,
        latitude: task.latitude,
        longitude: task.longitude,
        address: task.address,
        assignedToId: task.assignedToId,
        assignedToName: task.assignedToName,
        createdById: task.createdById,
        createdByName: task.createdByName,
        createdAt: task.createdAt,
        updatedAt: now,
        checkedInAt: task.checkedInAt,
        completedAt: now,
        photoUrls: task.photoUrls,
        checkInPhotoUrl: task.checkInPhotoUrl,
        completionPhotoUrl: photoUrl,
        syncStatus: task.syncStatus,
        completionNotes: completionNotes,
        metadata: task.metadata,
      );

      await firestore.collection('tasks').doc(id).update(
            updatedTask.toFirestore()
              ..['updatedAt'] = now.toIso8601String()
              ..['completedAt'] = now.toIso8601String(),
          );

      return updatedTask;
    } catch (e) {
      throw FirestoreException('Failed to complete task: $e');
    }
  }

  @override
  Stream<List<TaskModel>> watchTasks() {
    try {
      final userId = _currentUserId;

      final assignedStream = firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: userId)
          .snapshots();

      final createdStream = firestore
          .collection('tasks')
          .where('createdBy', isEqualTo: userId)
          .snapshots();

      return Rx.combineLatest2(
        assignedStream,
        createdStream,
        (assigned, created) {
          final tasksMap = <String, TaskModel>{};

          for (final doc in assigned.docs) {
            final task = TaskModel.fromFirestore(doc.data());
            tasksMap[task.id] = task;
          }

          for (final doc in created.docs) {
            final task = TaskModel.fromFirestore(doc.data());
            tasksMap[task.id] = task;
          }

          return tasksMap.values.toList();
        },
      );
    } catch (e) {
      return Stream.error(FirestoreException('Failed to watch tasks: $e'));
    }
  }

  @override
  Stream<TaskModel?> watchTaskById(String id) {
    return firestore.collection('tasks').doc(id).snapshots().map(
          (doc) => doc.exists ? TaskModel.fromFirestore(doc.data()!) : null,
        );
  }

  @override
  Future<List<TaskModel>> getTasksByStatus(String status) async {
    try {
      final userId = _currentUserId;

      final snapshot = await firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('dueDate', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw FirestoreException('Failed to get tasks by status: $e');
    }
  }

  @override
  Future<List<TaskModel>> getExpiredTasks() async {
    try {
      final userId = _currentUserId;
      final now = DateTime.now();

      // Get all non-completed tasks
      final snapshot = await firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'checked_in'])
          .orderBy('dueDate', descending: false)
          .get();

      // Filter expired tasks on the client side (due date has passed)
      final expiredTasks = snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc.data()))
          .where((task) => task.dueDateTime.isBefore(now))
          .toList();

      return expiredTasks;
    } catch (e) {
      throw FirestoreException('Failed to get expired tasks: $e');
    }
  }
}

class FirestoreException implements Exception {
  final String message;

  const FirestoreException(this.message);

  @override
  String toString() => 'FirestoreException: $message';
}
