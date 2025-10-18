import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/task_remote_datasource.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final tasks = await remoteDataSource.getTasks();
      // Cache locally
      for (final task in tasks) {
        try {
          await localDataSource.saveTask(task);
        } catch (e) {
          // Log but don't fail - local cache is secondary
          print('⚠️ Warning: Failed to cache task locally: $e');
        }
      }
      return Right(tasks);
    } catch (e) {
      print('❌ Error in getTasks: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(String id) async {
    try {
      final task = await remoteDataSource.getTaskById(id);
      await localDataSource.saveTask(task);
      return Right(task);
    } catch (e) {
      print('❌ Error in getTaskById: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
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
      final createdTask = await remoteDataSource.createTask(taskModel);
      try {
        await localDataSource.saveTask(createdTask);
      } catch (e) {
        // Log but don't fail - local cache is secondary
        print('⚠️ Warning: Failed to cache task locally: $e');
      }
      return Right(createdTask);
    } catch (e) {
      print('❌ Error in createTask: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
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
      final updatedTask = await remoteDataSource.updateTask(taskModel);
      await localDataSource.updateTask(updatedTask);
      return Right(updatedTask);
    } catch (e) {
      return Left(const TaskUpdateFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      await localDataSource.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(const TaskDeleteFailure());
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
      final task =
          await remoteDataSource.checkInTask(id, latitude, longitude, photoUrl);
      await localDataSource.updateTask(task);
      return Right(task);
    } catch (e) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> completeTask(
    String id,
    String? completionNotes,
    String? photoUrl,
  ) async {
    try {
      final task =
          await remoteDataSource.completeTask(id, completionNotes, photoUrl);
      await localDataSource.updateTask(task);
      return Right(task);
    } catch (e) {
      return Left(const ServerFailure());
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
