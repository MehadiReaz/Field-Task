import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@injectable
class CheckInTask extends UseCase<Task, CheckInTaskParams> {
  final TaskRepository repository;

  CheckInTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(CheckInTaskParams params) async {
    return repository.checkInTask(
      params.id,
      params.latitude,
      params.longitude,
      params.photoUrl,
    );
  }
}

class CheckInTaskParams {
  final String id;
  final double latitude;
  final double longitude;
  final String? photoUrl;

  CheckInTaskParams({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
  });
}
