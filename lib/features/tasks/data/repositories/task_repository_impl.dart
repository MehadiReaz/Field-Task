import 'dart:convert';
import 'package:dartz/dartz.dart' hide Task;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/network/network_info.dart';
import '../../../../database/database.dart';
import '../../../sync/presentation/bloc/sync_bloc.dart';
import '../../../sync/presentation/bloc/sync_event.dart';
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
  final FirebaseAuth firebaseAuth;
  final SyncBloc syncBloc;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.database,
    required this.firebaseAuth,
    required this.syncBloc,
  });

  // Helper method to get current user ID
  String get _currentUserId {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

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

      // Notify sync bloc to update pending count
      syncBloc.add(const GetSyncQueueCountEvent());
    } catch (_) {
      // Silently ignore queue failures
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Fetch from remote and cache
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
    } else {
      // Offline: Fetch from local database
      try {
        final userId = _currentUserId;
        final pendingTasks =
            await localDataSource.getTasksByStatus(userId, 'pending');
        final checkedInTasks =
            await localDataSource.getTasksByStatus(userId, 'checked_in');
        final allTasks = [...pendingTasks, ...checkedInTasks];
        // Sort by due date
        allTasks.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
        return Right(allTasks);
      } catch (e) {
        return Left(CacheFailure(
            'Failed to fetch tasks from local database: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, TaskPage>> getTasksPage({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
    String? status,
    bool showExpiredOnly = false,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Fetch from remote and cache locally
      try {
        final pageModel = await remoteDataSource.getTasksPage(
          lastDocument: lastDocument,
          pageSize: pageSize,
          status: status,
          showExpiredOnly: showExpiredOnly,
        );

        // Cache tasks in background
        for (final task in pageModel.tasks) {
          _cacheTaskSilently(task);
        }

        return Right(TaskPage(
          tasks: pageModel.tasks,
          hasMore: pageModel.hasMore,
          lastDocument: pageModel.lastDocument,
        ));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Fetch from local database
      try {
        final userId = _currentUserId;
        List<TaskModel> localTasks;

        if (showExpiredOnly) {
          // Get expired tasks
          localTasks = await localDataSource.getExpiredTasks(userId);
        } else if (status != null) {
          // Get tasks by status
          localTasks = await localDataSource.getTasksByStatus(userId, status);
        } else {
          // Get all pending/checked-in tasks
          final pendingTasks =
              await localDataSource.getTasksByStatus(userId, 'pending');
          final checkedInTasks =
              await localDataSource.getTasksByStatus(userId, 'checked_in');
          localTasks = [...pendingTasks, ...checkedInTasks];
          // Sort by due date
          localTasks.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
        }

        // For offline mode, we don't have pagination support
        // Return all matching tasks with hasMore = false
        return Right(TaskPage(
          tasks: localTasks,
          hasMore: false,
          lastDocument: null,
        ));
      } catch (e) {
        return Left(CacheFailure(
            'Failed to fetch tasks from local database: ${e.toString()}'));
      }
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
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Save to server and cache locally
      try {
        final createdTask = await remoteDataSource.createTask(_toModel(task));
        await _cacheTaskSilently(createdTask);
        return Right(createdTask);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Save to local database and queue for sync
      try {
        final taskWithSyncStatus = task.copyWith(
          syncStatus: SyncStatus.pending,
          updatedAt: DateTime.now(),
        );

        final taskModel = _toModel(taskWithSyncStatus);
        await localDataSource.saveTask(taskModel);

        // Add to sync queue
        final payload = json.encode(taskModel.toFirestore());
        await _addToSyncQueue(task.id, 'create', payload);

        return Right(taskWithSyncStatus);
      } catch (e) {
        return Left(
            CacheFailure('Failed to save task offline: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Update on server and cache locally
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
    } else {
      // Offline: Update local database and queue for sync
      try {
        final taskWithSyncStatus = task.copyWith(
          syncStatus: SyncStatus.pending,
          updatedAt: DateTime.now(),
        );

        final taskModel = _toModel(taskWithSyncStatus);
        await localDataSource.updateTask(taskModel);

        // Add to sync queue
        final payload = json.encode(taskModel.toFirestore());
        await _addToSyncQueue(task.id, 'update', payload);

        return Right(taskWithSyncStatus);
      } catch (e) {
        return Left(
            CacheFailure('Failed to update task offline: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Delete from server and cache
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
    } else {
      // Offline: Delete from local database and queue for sync
      try {
        await localDataSource.deleteTask(id);

        // Add to sync queue (no payload needed for delete)
        await _addToSyncQueue(id, 'delete', '{}');

        return const Right(null);
      } catch (e) {
        return Left(
            CacheFailure('Failed to delete task offline: ${e.toString()}'));
      }
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
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Fetch from remote and cache
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
    } else {
      // Offline: Fetch from local database
      try {
        final userId = _currentUserId;
        final tasks = await localDataSource.getTasksByStatus(userId, status);
        return Right(tasks);
      } catch (e) {
        return Left(CacheFailure(
            'Failed to fetch tasks from local database: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getExpiredTasks() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Fetch from remote and cache
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
    } else {
      // Offline: Fetch from local database
      try {
        final userId = _currentUserId;
        final tasks = await localDataSource.getExpiredTasks(userId);
        return Right(tasks);
      } catch (e) {
        return Left(CacheFailure(
            'Failed to fetch expired tasks from local database: ${e.toString()}'));
      }
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
