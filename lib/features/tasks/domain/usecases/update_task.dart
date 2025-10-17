import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@injectable
class UpdateTask extends UseCase<Task, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(UpdateTaskParams params) async {
    return repository.updateTask(params.task);
  }
}

class UpdateTaskParams {
  final Task task;

  UpdateTaskParams(this.task);
}
