import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/location_data.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationData>> getCurrentLocation();

  Future<Either<Failure, String>> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, LocationData>> getCoordinatesFromAddress(
    String address,
  );

  Future<Either<Failure, double>> calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });

  Future<Either<Failure, bool>> isWithinProximity({
    required double currentLatitude,
    required double currentLongitude,
    required double targetLatitude,
    required double targetLongitude,
    double thresholdMeters = 100.0,
  });

  Future<Either<Failure, bool>> requestLocationPermission();

  Future<Either<Failure, bool>> checkLocationPermission();

  Future<Either<Failure, bool>> isLocationServiceEnabled();
}
