import 'dart:convert';
import 'package:dartz/dartz.dart' hide Task;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/network/network_info.dart';
import '../../../../database/database.dart';
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
  final NetworkInfo networkInfo;
  final AppDatabase database;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.database,
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

  // Helper method to add operation to sync queue
  Future<void> _addToSyncQueue(
      String taskId, String operation, String payload) async {
    try {
      await database.syncQueueDao.addToQueue(
        SyncQueueCompanion.insert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          taskId: taskId,
          operation: operation,
          payload: payload,
          timestamp: DateTime.now(),
        ),
      );
    } catch (_) {
      // Silently ignore queue failures
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
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Fetch from server
      try {
        final task = await remoteDataSource.getTaskById(id);
        await _cacheTaskSilently(task);
        return Right(task);
      } catch (e) {
        // If server fails, try local cache as fallback
        try {
          final localTask = await localDataSource.getTaskById(id);
          if (localTask != null) {
            return Right(localTask);
          }
        } catch (_) {}
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Fetch from local database
      try {
        final localTask = await localDataSource.getTaskById(id);
        if (localTask != null) {
          return Right(localTask);
        }
        return Left(CacheFailure('Task not found in local database'));
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
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

      return const Right(null);
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
    // Check if online
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Send to server immediately
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
    } else {
      // Offline: Update local database and queue for sync
      try {
        final localTask = await localDataSource.getTaskById(id);

        if (localTask == null) {
          return Left(CacheFailure('Task not found in local database'));
        }

        final updatedTask = localTask.copyWith(
          status: TaskStatus.checkedIn,
          latitude: latitude,
          longitude: longitude,
          checkedInAt: DateTime.now(),
          checkInPhotoUrl: photoUrl,
          syncStatus: SyncStatus.pending,
          updatedAt: DateTime.now(),
        );

        await localDataSource.updateTask(_toModel(updatedTask));

        // Add to sync queue with specific check-in data
        final payload = json.encode({
          'taskId': id,
          'locationLat': latitude,
          'locationLng': longitude,
          'checkInPhotoUrl': photoUrl,
        });
        await _addToSyncQueue(id, 'check_in', payload);

        return Right(updatedTask);
      } catch (e) {
        return Left(
            CacheFailure('Failed to check-in offline: ${e.toString()}'));
      }
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
    // Check if online
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Send to server immediately
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
    } else {
      // Offline: Update local database and queue for sync
      try {
        final localTask = await localDataSource.getTaskById(id);

        if (localTask == null) {
          return Left(CacheFailure('Task not found in local database'));
        }

        final updatedTask = localTask.copyWith(
          status: TaskStatus.completed,
          completedAt: DateTime.now(),
          completionNotes: completionNotes,
          completionPhotoUrl: photoUrl,
          syncStatus: SyncStatus.pending,
          updatedAt: DateTime.now(),
        );

        await localDataSource.updateTask(_toModel(updatedTask));

        // Add to sync queue with specific completion data
        final payload = json.encode({
          'taskId': id,
          'completionNotes': completionNotes,
          'completionPhotoUrl': photoUrl,
        });
        await _addToSyncQueue(id, 'complete', payload);

        return Right(updatedTask);
      } catch (e) {
        return Left(
            CacheFailure('Failed to complete offline: ${e.toString()}'));
      }
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
  Future<Either<Failure, List<Task>>> getTasksByStatus(String status) async {
    try {
      final tasks = await remoteDataSource.getTasksByStatus(status);

      // Cache tasks in background
      for (final task in tasks) {
        _cacheTaskSilently(task);
      }

      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getExpiredTasks() async {
    try {
      final tasks = await remoteDataSource.getExpiredTasks();

      // Cache tasks in background
      for (final task in tasks) {
        _cacheTaskSilently(task);
      }

      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByStatusLocal(
    String userId,
    String status,
  ) async {
    try {
      final tasks = await localDataSource.getTasksByStatus(userId, status);
      return Right(tasks);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getExpiredTasksLocal(
      String userId) async {
    try {
      final tasks = await localDataSource.getExpiredTasks(userId);
      return Right(tasks);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
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
