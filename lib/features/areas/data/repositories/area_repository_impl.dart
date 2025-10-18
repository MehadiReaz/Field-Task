import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../domain/entities/area.dart';
import '../../domain/repositories/area_repository.dart';
import '../datasources/area_remote_data_source.dart';
import '../models/area_model.dart';

@LazySingleton(as: AreaRepository)
class AreaRepositoryImpl implements AreaRepository {
  final AreaRemoteDataSource remoteDataSource;

  AreaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Area>> createArea(Area area) async {
    try {
      final areaModel = AreaModel.fromEntity(area);
      final result = await remoteDataSource.createArea(areaModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Area>>> getAreas() async {
    try {
      final areas = await remoteDataSource.getAreas();
      return Right(areas);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Area>> getAreaById(String id) async {
    try {
      final area = await remoteDataSource.getAreaById(id);
      return Right(area);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Area>>> getAreasByAgentId(String agentId) async {
    try {
      final areas = await remoteDataSource.getAreasByAgentId(agentId);
      return Right(areas);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Area>> updateArea(Area area) async {
    try {
      final areaModel = AreaModel.fromEntity(area);
      final result = await remoteDataSource.updateArea(areaModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteArea(String id) async {
    try {
      await remoteDataSource.deleteArea(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isLocationInArea({
    required String areaId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final areaResult = await remoteDataSource.getAreaById(areaId);

      final isWithin = DistanceCalculator.isWithinRadius(
        startLatitude: latitude,
        startLongitude: longitude,
        endLatitude: areaResult.centerLatitude,
        endLongitude: areaResult.centerLongitude,
        radiusInMeters: areaResult.radiusInMeters,
      );

      return Right(isWithin);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Area>>> getAreasContainingLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final allAreas = await remoteDataSource.getAreas();

      final containingAreas = allAreas.where((area) {
        return DistanceCalculator.isWithinRadius(
          startLatitude: latitude,
          startLongitude: longitude,
          endLatitude: area.centerLatitude,
          endLongitude: area.centerLongitude,
          radiusInMeters: area.radiusInMeters,
        );
      }).toList();

      return Right(containingAreas);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
