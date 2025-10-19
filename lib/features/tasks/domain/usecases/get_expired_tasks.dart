import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@lazySingleton
class GetExpiredTasks implements UseCase<List<Task>, GetExpiredTasksParams> {
  final TaskRepository repository;

  GetExpiredTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(GetExpiredTasksParams params) async {
    if (params.useLocal && params.userId != null) {
      return await repository.getExpiredTasksLocal(params.userId!);
    }
    return await repository.getExpiredTasks();
  }
}

class GetExpiredTasksParams {
  final bool useLocal;
  final String? userId;

  GetExpiredTasksParams({
    this.useLocal = false,
    this.userId,
  });
}
