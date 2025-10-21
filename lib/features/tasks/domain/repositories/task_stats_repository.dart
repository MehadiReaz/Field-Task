import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/task_stats.dart';

abstract class ITaskStatsRepository {
  Future<Either<Failure, TaskStats>> getTaskStats();
  Future<Either<Failure, TaskStats>> calculateAndSaveStats();
}
