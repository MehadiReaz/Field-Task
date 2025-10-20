import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/location_data.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_datasource.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, LocationData>> getCurrentLocation() async {
    try {
      final location = await dataSource.getCurrentLocation();
      return Right(location);
    } on LocationException catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(LocationFailure('Failed to get current location: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final address = await dataSource.getAddressFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(address);
    } catch (e) {
      return Left(LocationFailure('Failed to get address: $e'));
    }
  }

  @override
  Future<Either<Failure, LocationData>> getCoordinatesFromAddress(
    String address,
  ) async {
    try {
      final location = await dataSource.getCoordinatesFromAddress(address);
      return Right(location);
    } catch (e) {
      return Left(LocationFailure('Failed to get coordinates: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    try {
      final distance = await dataSource.calculateDistance(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );
      return Right(distance);
    } catch (e) {
      return Left(LocationFailure('Failed to calculate distance: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isWithinProximity({
    required double currentLatitude,
    required double currentLongitude,
    required double targetLatitude,
    required double targetLongitude,
    double thresholdMeters = 100.0,
  }) async {
    try {
      final isWithin = await dataSource.isWithinProximity(
        currentLatitude: currentLatitude,
        currentLongitude: currentLongitude,
        targetLatitude: targetLatitude,
        targetLongitude: targetLongitude,
        thresholdMeters: thresholdMeters,
      );
      return Right(isWithin);
    } catch (e) {
      return Left(LocationFailure('Failed to validate proximity: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final granted = await dataSource.requestLocationPermission();
      return Right(granted);
    } catch (e) {
      return const Left(LocationPermissionDeniedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocationPermission() async {
    try {
      final granted = await dataSource.checkLocationPermission();
      return Right(granted);
    } catch (e) {
      return const Left(LocationPermissionDeniedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isLocationServiceEnabled() async {
    try {
      final enabled = await dataSource.isLocationServiceEnabled();
      return Right(enabled);
    } catch (e) {
      return const Left(LocationServiceDisabledFailure());
    }
  }
}
