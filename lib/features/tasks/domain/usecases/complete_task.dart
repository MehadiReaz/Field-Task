import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@injectable
class CompleteTask extends UseCase<Task, CompleteTaskParams> {
  final TaskRepository repository;

  CompleteTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(CompleteTaskParams params) async {
    return repository.completeTask(
      params.id,
      params.completionNotes,
      params.photoUrl,
    );
  }
}

class CompleteTaskParams {
  final String id;
  final String? completionNotes;
  final String? photoUrl;

  CompleteTaskParams({
    required this.id,
    this.completionNotes,
    this.photoUrl,
  });
}
