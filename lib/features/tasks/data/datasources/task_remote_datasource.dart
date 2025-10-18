import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
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

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const FirestoreException('User not authenticated');
      }

      // Get user's selected area
      final userDoc =
          await firestore.collection('users').doc(currentUser.uid).get();
      final selectedAreaId = userDoc.data()?['selectedAreaId'] as String?;

      // If no area selected, return empty list
      if (selectedAreaId == null) {
        print('⚠️ User has no selected area');
        return [];
      }

      // Query tasks assigned to the current user AND in their selected area
      final assignedSnapshot = await firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: currentUser.uid)
          .where('areaId', isEqualTo: selectedAreaId)
          .get();

      // Query tasks created by the current user AND in their selected area
      final createdSnapshot = await firestore
          .collection('tasks')
          .where('createdBy', isEqualTo: currentUser.uid)
          .where('areaId', isEqualTo: selectedAreaId)
          .get();

      // Combine and deduplicate tasks
      final tasksMap = <String, TaskModel>{};

      for (final doc in assignedSnapshot.docs) {
        final task = TaskModel.fromFirestore(doc.data());
        tasksMap[task.id] = task;
      }

      for (final doc in createdSnapshot.docs) {
        final task = TaskModel.fromFirestore(doc.data());
        tasksMap[task.id] = task;
      }

      print('✅ Fetched ${tasksMap.length} tasks for area: $selectedAreaId');
      return tasksMap.values.toList();
    } catch (e) {
      throw FirestoreException('Failed to fetch tasks: $e');
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
        areaId: task.areaId, // Include areaId
        assignedToId: task.assignedToId,
        assignedToName: task.assignedToName,
        createdById: task.createdById,
        createdByName: task.createdByName,
        createdAt: task.createdAt,
        updatedAt: DateTime.now(),
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
      await firestore.collection('tasks').doc(task.id).update(
            task.toFirestore()
              ..['updatedAt'] = DateTime.now().toIso8601String(),
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
      final doc = await firestore.collection('tasks').doc(id).get();
      if (!doc.exists) {
        throw const FirestoreException('Task not found');
      }

      final task = TaskModel.fromFirestore(doc.data()!);
      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDateTime: task.dueDateTime,
        status: task.status,
        priority: task.priority,
        latitude: latitude,
        longitude: longitude,
        address: task.address,
        areaId: task.areaId, // Preserve areaId
        assignedToId: task.assignedToId,
        assignedToName: task.assignedToName,
        createdById: task.createdById,
        createdByName: task.createdByName,
        createdAt: task.createdAt,
        updatedAt: DateTime.now(),
        checkedInAt: DateTime.now(),
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
            ..['updatedAt'] = DateTime.now().toIso8601String());

      return updatedTask;
    } catch (e) {
      throw FirestoreException('Failed to check in task: $e');
    }
  }

  @override
  Future<TaskModel> completeTask(
    String id,
    String? completionNotes,
    String? photoUrl,
  ) async {
    try {
      final doc = await firestore.collection('tasks').doc(id).get();
      if (!doc.exists) {
        throw const FirestoreException('Task not found');
      }

      final task = TaskModel.fromFirestore(doc.data()!);
      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDateTime: task.dueDateTime,
        status: task.status,
        priority: task.priority,
        latitude: task.latitude,
        longitude: task.longitude,
        address: task.address,
        areaId: task.areaId, // Preserve areaId
        assignedToId: task.assignedToId,
        assignedToName: task.assignedToName,
        createdById: task.createdById,
        createdByName: task.createdByName,
        createdAt: task.createdAt,
        updatedAt: DateTime.now(),
        checkedInAt: task.checkedInAt,
        completedAt: DateTime.now(),
        photoUrls: task.photoUrls,
        checkInPhotoUrl: task.checkInPhotoUrl,
        completionPhotoUrl: photoUrl,
        syncStatus: task.syncStatus,
        completionNotes: completionNotes,
        metadata: task.metadata,
      );

      await firestore.collection('tasks').doc(id).update(
          updatedTask.toFirestore()
            ..['updatedAt'] = DateTime.now().toIso8601String());

      return updatedTask;
    } catch (e) {
      throw FirestoreException('Failed to complete task: $e');
    }
  }

  @override
  Stream<List<TaskModel>> watchTasks() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      return Stream.error(const FirestoreException('User not authenticated'));
    }

    // Get user's selected area and watch for changes
    return firestore
        .collection('users')
        .doc(currentUser.uid)
        .snapshots()
        .asyncExpand((userDoc) {
      final selectedAreaId = userDoc.data()?['selectedAreaId'] as String?;

      // If no area selected, return empty stream
      if (selectedAreaId == null) {
        print('⚠️ User has no selected area for watching tasks');
        return Stream.value(<TaskModel>[]);
      }

      // Watch tasks assigned to the current user AND in their selected area
      final assignedStream = firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: currentUser.uid)
          .where('areaId', isEqualTo: selectedAreaId)
          .snapshots();

      // Watch tasks created by the current user AND in their selected area
      final createdStream = firestore
          .collection('tasks')
          .where('createdBy', isEqualTo: currentUser.uid)
          .where('areaId', isEqualTo: selectedAreaId)
          .snapshots();

      // Combine both streams
      return Rx.combineLatest2(assignedStream, createdStream,
          (assigned, created) {
        final tasksMap = <String, TaskModel>{};

        // Add assigned tasks
        for (final doc in assigned.docs) {
          final task = TaskModel.fromFirestore(doc.data());
          tasksMap[task.id] = task;
        }

        // Add created tasks (overwrites if same ID)
        for (final doc in created.docs) {
          final task = TaskModel.fromFirestore(doc.data());
          tasksMap[task.id] = task;
        }

        print('✅ Watching ${tasksMap.length} tasks for area: $selectedAreaId');
        return tasksMap.values.toList();
      });
    });
  }

  @override
  Stream<TaskModel?> watchTaskById(String id) {
    return firestore.collection('tasks').doc(id).snapshots().map(
          (doc) => doc.exists ? TaskModel.fromFirestore(doc.data()!) : null,
        );
  }
}

class FirestoreException implements Exception {
  final String message;

  const FirestoreException(this.message);

  @override
  String toString() => message;
}
