import 'package:dartz/dartz.dart' hide Task;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/task_remote_datasource.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';
import '../../domain/entities/task.dart';
import '../../domain/models/task_page.dart';
import '../../domain/repositories/task_repository.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Helper method to convert Task entity to TaskModel
  TaskModel _toModel(Task task) {
    return TaskModel(
      id: task.id,
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
      updatedAt: task.updatedAt,
      checkedInAt: task.checkedInAt,
      completedAt: task.completedAt,
      photoUrls: task.photoUrls,
      checkInPhotoUrl: task.checkInPhotoUrl,
      completionPhotoUrl: task.completionPhotoUrl,
      syncStatus: task.syncStatus,
      completionNotes: task.completionNotes,
      metadata: task.metadata,
    );
  }

  // Helper method to cache task locally (non-blocking)
  Future<void> _cacheTaskSilently(TaskModel task) async {
    try {
      await localDataSource.saveTask(task);
    } catch (_) {
      // Silently ignore cache failures
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final tasks = await remoteDataSource.getTasks();

      // Cache tasks in background without blocking
      for (final task in tasks) {
        _cacheTaskSilently(task);
      }

      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskPage>> getTasksPage({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
    String? status,
    bool showExpiredOnly = false,
  }) async {
    try {
      final pageModel = await remoteDataSource.getTasksPage(
        lastDocument: lastDocument,
        pageSize: pageSize,
        status: status,
        showExpiredOnly: showExpiredOnly,
      );

      return Right(TaskPage(
        tasks: pageModel.tasks,
        hasMore: pageModel.hasMore,
        lastDocument: pageModel.lastDocument,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(String id) async {
    try {
      final task = await remoteDataSource.getTaskById(id);
      await _cacheTaskSilently(task);
      return Right(task);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final createdTask = await remoteDataSource.createTask(_toModel(task));
      await _cacheTaskSilently(createdTask);
      return Right(createdTask);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final updatedTask = await remoteDataSource.updateTask(_toModel(task));

      try {
        await localDataSource.updateTask(updatedTask);
      } catch (_) {
        // Cache update failure is non-critical
      }

      return Right(updatedTask);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);

      try {
        await localDataSource.deleteTask(id);
      } catch (_) {
        // Cache deletion failure is non-critical
      }

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> checkInTask(
    String id,
    double latitude,
    double longitude,
    String? photoUrl,
  ) async {
    try {
      final task = await remoteDataSource.checkInTask(
        id,
        latitude,
        longitude,
        photoUrl,
      );

      try {
        await localDataSource.updateTask(task);
      } catch (_) {
        // Cache update failure is non-critical
      }

      return Right(task);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> checkoutTask(String id) async {
    try {
      final task = await remoteDataSource.checkoutTask(id);

      try {
        await localDataSource.updateTask(task);
      } catch (_) {
        // Cache update failure is non-critical
      }

      return Right(task);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> completeTask(
    String id,
    String? completionNotes,
    String? photoUrl,
  ) async {
    try {
      final task = await remoteDataSource.completeTask(
        id,
        completionNotes,
        photoUrl,
      );

      try {
        await localDataSource.updateTask(task);
      } catch (_) {
        // Cache update failure is non-critical
      }

      return Right(task);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> searchTasks({
    required String query,
    List<String> searchFields = const ['title', 'description'],
  }) async {
    try {
      final tasks = await remoteDataSource.searchTasks(
        query: query,
        searchFields: searchFields,
      );
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> searchTasksLocal({
    required String query,
    List<String> searchFields = const ['title', 'description'],
  }) async {
    try {
      final tasks = await localDataSource.searchTasks(
        query: query,
        searchFields: searchFields,
      );
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<Task>> watchTasks() {
    return remoteDataSource.watchTasks();
  }

  @override
  Stream<Task?> watchTaskById(String id) {
    return remoteDataSource.watchTaskById(id);
  }
}
