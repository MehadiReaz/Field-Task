import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Task>> getTaskById(String id);
  Future<Either<Failure, Task>> createTask(Task task);
  Future<Either<Failure, Task>> updateTask(Task task);
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, Task>> checkInTask(
      String id, double latitude, double longitude, String? photoUrl);
  Future<Either<Failure, Task>> completeTask(
      String id, String? completionNotes, String? photoUrl);
  Stream<List<Task>> watchTasks();
  Stream<Task?> watchTaskById(String id);
}
