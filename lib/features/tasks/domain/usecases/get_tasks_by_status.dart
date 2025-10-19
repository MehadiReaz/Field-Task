import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@lazySingleton
class GetTasksByStatus implements UseCase<List<Task>, GetTasksByStatusParams> {
  final TaskRepository repository;

  GetTasksByStatus(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(
      GetTasksByStatusParams params) async {
    if (params.useLocal && params.userId != null) {
      return await repository.getTasksByStatusLocal(
          params.userId!, params.status);
    }
    return await repository.getTasksByStatus(params.status);
  }
}

class GetTasksByStatusParams {
  final String status;
  final bool useLocal;
  final String? userId;

  GetTasksByStatusParams({
    required this.status,
    this.useLocal = false,
    this.userId,
  });
}
