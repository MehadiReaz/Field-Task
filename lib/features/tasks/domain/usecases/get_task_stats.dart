import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_stats.dart';
import '../repositories/task_stats_repository.dart';

@injectable
class GetTaskStats implements UseCase<TaskStats, NoParams> {
  final ITaskStatsRepository repository;

  GetTaskStats(this.repository);

  @override
  Future<Either<Failure, TaskStats>> call(NoParams params) async {
    return await repository.getTaskStats();
  }
}

@injectable
class CalculateAndSaveTaskStats implements UseCase<TaskStats, NoParams> {
  final ITaskStatsRepository repository;

  CalculateAndSaveTaskStats(this.repository);

  @override
  Future<Either<Failure, TaskStats>> call(NoParams params) async {
    return await repository.calculateAndSaveStats();
  }
}
