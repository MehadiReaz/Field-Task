import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import '../models/location_model.dart';

abstract class LocationDataSource {
  Future<LocationModel> getCurrentLocation();
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });
  Future<LocationModel> getCoordinatesFromAddress(String address);
  Future<double> calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
  Future<bool> isWithinProximity({
    required double currentLatitude,
    required double currentLongitude,
    required double targetLatitude,
    required double targetLongitude,
    double thresholdMeters = 100.0,
  });
  Future<bool> requestLocationPermission();
  Future<bool> checkLocationPermission();
  Future<bool> isLocationServiceEnabled();
}

@LazySingleton(as: LocationDataSource)
class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<LocationModel> getCurrentLocation() async {
    // Check if location service is enabled
    final isEnabled = await isLocationServiceEnabled();
    if (!isEnabled) {
      throw Exception('Location service is disabled');
    }

    // Check and request permission
    bool hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      hasPermission = await requestLocationPermission();
    }

    if (!hasPermission) {
      throw Exception('Location permission denied');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String? address;
    try {
      address = await getAddressFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      // Address fetch failed, continue without it
    }

    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
    );
  }

  @override
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final parts = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((e) => e != null && e.isNotEmpty);

      return parts.join(', ');
    }
    return 'Unknown location';
  }

  @override
  Future<LocationModel> getCoordinatesFromAddress(String address) async {
    final locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      final location = locations.first;
      return LocationModel(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address,
        timestamp: DateTime.now(),
      );
    }
    throw Exception('Could not find coordinates for address');
  }

  @override
  Future<double> calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  @override
  Future<bool> isWithinProximity({
    required double currentLatitude,
    required double currentLongitude,
    required double targetLatitude,
    required double targetLongitude,
    double thresholdMeters = 100.0,
  }) async {
    final distance = await calculateDistance(
      startLatitude: currentLatitude,
      startLongitude: currentLongitude,
      endLatitude: targetLatitude,
      endLongitude: targetLongitude,
    );
    return distance <= thresholdMeters;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
