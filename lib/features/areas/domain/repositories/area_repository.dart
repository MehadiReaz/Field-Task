import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/area.dart';

abstract class AreaRepository {
  /// Create a new area
  Future<Either<Failure, Area>> createArea(Area area);

  /// Get all areas
  Future<Either<Failure, List<Area>>> getAreas();

  /// Get a specific area by id
  Future<Either<Failure, Area>> getAreaById(String id);

  /// Get areas assigned to a specific agent
  Future<Either<Failure, List<Area>>> getAreasByAgentId(String agentId);

  /// Update an existing area
  Future<Either<Failure, Area>> updateArea(Area area);

  /// Delete an area
  Future<Either<Failure, void>> deleteArea(String id);

  /// Check if a location is within an area
  Future<Either<Failure, bool>> isLocationInArea({
    required String areaId,
    required double latitude,
    required double longitude,
  });

  /// Get all areas that contain a specific location
  Future<Either<Failure, List<Area>>> getAreasContainingLocation({
    required double latitude,
    required double longitude,
  });
}
