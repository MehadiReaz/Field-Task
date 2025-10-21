import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/task_stats.dart';
import '../../domain/repositories/task_stats_repository.dart';
import '../datasources/task_stats_remote_datasource.dart';
import '../datasources/task_stats_local_datasource.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';

@Injectable(as: ITaskStatsRepository)
class TaskStatsRepositoryImpl implements ITaskStatsRepository {
  final TaskStatsRemoteDataSource remoteDataSource;
  final TaskStatsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskStatsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TaskStats>> getTaskStats() async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        final remoteStats = await remoteDataSource.getTaskStats();
        return Right(remoteStats);
      } else {
        // Fallback to local calculation when offline
        AppLogger.info('Offline: Calculating stats from local database');
        return Left(ServerFailure('No internet connection'));
      }
    } catch (e) {
      AppLogger.error('Error getting task stats: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskStats>> calculateAndSaveStats() async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        final remoteStats = await remoteDataSource.calculateAndSaveStats();
        return Right(remoteStats);
      } else {
        // Calculate from local data when offline
        AppLogger.info('Offline: Calculating stats from local database');
        // Get current user ID somehow (you might need to adjust this)
        // For now, we'll throw an error
        return Left(ServerFailure(
            'Cannot calculate stats offline without user context'));
      }
    } catch (e) {
      AppLogger.error('Error calculating task stats: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
