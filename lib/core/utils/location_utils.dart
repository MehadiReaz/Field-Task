import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationUtils {
  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission status
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current position
  static Future<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: accuracy,
    );
  }

  // Get last known position
  static Future<Position?> getLastKnownPosition() async {
    return await Geolocator.getLastKnownPosition();
  }

  // Calculate distance between two points in meters
  static double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Check if within proximity threshold (default 100m)
  static bool isWithinProximity({
    required double currentLatitude,
    required double currentLongitude,
    required double targetLatitude,
    required double targetLongitude,
    double thresholdMeters = 100.0,
  }) {
    final distance = calculateDistance(
      startLatitude: currentLatitude,
      startLongitude: currentLongitude,
      endLatitude: targetLatitude,
      endLongitude: targetLongitude,
    );
    return distance <= thresholdMeters;
  }

  // Format distance for display
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
  }

  // Get address from coordinates (reverse geocoding)
  static Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
        return address.isNotEmpty ? address : null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get coordinates from address (forward geocoding)
  static Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Open location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // Open app settings
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  // Get location permission message
  static String getPermissionMessage(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return 'Location permission denied. Please grant permission to continue.';
      case LocationPermission.deniedForever:
        return 'Location permission permanently denied. Please enable it in app settings.';
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return 'Location permission granted';
      default:
        return 'Unknown permission status';
    }
  }

  // Check and request location permission with proper handling
  static Future<bool> handleLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check permission
    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get bearing between two points (direction)
  static double calculateBearing({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Format coordinates for display
  static String formatCoordinates(double latitude, double longitude) {
    final latDirection = latitude >= 0 ? 'N' : 'S';
    final lonDirection = longitude >= 0 ? 'E' : 'W';
    return '${latitude.abs().toStringAsFixed(6)}°$latDirection, ${longitude.abs().toStringAsFixed(6)}°$lonDirection';
  }
}
