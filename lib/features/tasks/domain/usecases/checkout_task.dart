import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@injectable
class CheckoutTask extends UseCase<Task, CheckoutTaskParams> {
  final TaskRepository repository;

  CheckoutTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(CheckoutTaskParams params) async {
    return repository.checkoutTask(params.id);
  }
}

class CheckoutTaskParams {
  final String id;

  CheckoutTaskParams({required this.id});
}
