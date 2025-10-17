import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../database/database.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<void> saveTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Stream<List<TaskModel>> watchTasks();
  Stream<TaskModel?> watchTaskById(String id);
}

@LazySingleton(as: TaskLocalDataSource)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final AppDatabase database;

  TaskLocalDataSourceImpl(this.database);

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      // For now, return empty list - would need to get userId from current user
      // This would typically be called with a specific user ID
      return [];
    } catch (e) {
      throw LocalDatabaseException('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final task = await database.taskDao.getTaskById(id);
      return task != null
          ? TaskModel.fromFirestore(_taskEntityToMap(task))
          : null;
    } catch (e) {
      throw LocalDatabaseException('Failed to fetch task: $e');
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    try {
      final companion = TasksCompanion(
        id: Value(task.id),
        title: Value(task.title),
        description: Value(task.description),
        dueDateTime: Value(task.dueDateTime),
        status: Value(task.status.value),
        priority: Value(task.priority.value),
        latitude: Value(task.latitude),
        longitude: Value(task.longitude),
        address: Value(task.address),
        assignedToId: Value(task.assignedToId),
        assignedToName: Value(task.assignedToName),
        createdById: Value(task.createdById),
        createdByName: Value(task.createdByName),
        createdAt: Value(task.createdAt),
        updatedAt: Value(task.updatedAt),
        checkedInAt: Value(task.checkedInAt),
        completedAt: Value(task.completedAt),
        photoUrls: Value(task.photoUrls?.join(',')),
        checkInPhotoUrl: Value(task.checkInPhotoUrl),
        completionPhotoUrl: Value(task.completionPhotoUrl),
        syncStatus: Value(task.syncStatus.value),
        syncRetryCount: Value(task.syncRetryCount),
        completionNotes: Value(task.completionNotes),
      );
      await database.taskDao.insertTask(companion);
    } catch (e) {
      throw LocalDatabaseException('Failed to save task: $e');
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      final entity = TaskEntity(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDateTime: task.dueDateTime,
        status: task.status.value,
        priority: task.priority.value,
        latitude: task.latitude,
        longitude: task.longitude,
        address: task.address,
        assignedToId: task.assignedToId,
        assignedToName: task.assignedToName,
        createdById: task.createdById,
        createdByName: task.createdByName,
        createdAt: task.createdAt,
        updatedAt: task.updatedAt,
        checkedInAt: task.checkedInAt,
        completedAt: task.completedAt,
        photoUrls: task.photoUrls?.join(','),
        checkInPhotoUrl: task.checkInPhotoUrl,
        completionPhotoUrl: task.completionPhotoUrl,
        syncStatus: task.syncStatus.value,
        syncRetryCount: task.syncRetryCount,
        completionNotes: task.completionNotes,
      );
      await database.taskDao.updateTask(entity);
    } catch (e) {
      throw LocalDatabaseException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await database.taskDao.deleteTask(id);
    } catch (e) {
      throw LocalDatabaseException('Failed to delete task: $e');
    }
  }

  @override
  Stream<List<TaskModel>> watchTasks() {
    // Return empty stream for now - would need userId
    return Stream.value([]);
  }

  @override
  Stream<TaskModel?> watchTaskById(String id) {
    return Stream.value(null);
  }

  // Helper to convert TaskEntity to Map for TaskModel
  Map<String, dynamic> _taskEntityToMap(TaskEntity entity) {
    return {
      'id': entity.id,
      'title': entity.title,
      'description': entity.description,
      'dueDate': entity.dueDateTime.toIso8601String(),
      'status': entity.status,
      'priority': entity.priority,
      'locationLat': entity.latitude,
      'locationLng': entity.longitude,
      'locationAddress': entity.address,
      'assignedTo': entity.assignedToId,
      'assignedToName': entity.assignedToName,
      'createdBy': entity.createdById,
      'createdByName': entity.createdByName,
      'createdAt': entity.createdAt.toIso8601String(),
      'updatedAt': entity.updatedAt.toIso8601String(),
      'checkedInAt': entity.checkedInAt?.toIso8601String(),
      'completedAt': entity.completedAt?.toIso8601String(),
      'photoUrls': entity.photoUrls?.split(','),
      'checkInPhotoUrl': entity.checkInPhotoUrl,
      'completionPhotoUrl': entity.completionPhotoUrl,
      'completionNotes': entity.completionNotes,
    };
  }
}

class LocalDatabaseException implements Exception {
  final String message;

  LocalDatabaseException(this.message);

  @override
  String toString() => message;
}
