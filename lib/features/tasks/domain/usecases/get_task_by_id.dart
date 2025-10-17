import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@injectable
class GetTaskById extends UseCase<Task, GetTaskByIdParams> {
  final TaskRepository repository;

  GetTaskById(this.repository);

  @override
  Future<Either<Failure, Task>> call(GetTaskByIdParams params) async {
    return repository.getTaskById(params.id);
  }
}

class GetTaskByIdParams {
  final String id;

  GetTaskByIdParams(this.id);
}
