import 'dart:math';

class DistanceCalculator {
  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in meters
  static double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(endLatitude - startLatitude);
    final dLon = _degreesToRadians(endLongitude - startLongitude);

    final lat1 = _degreesToRadians(startLatitude);
    final lat2 = _degreesToRadians(endLatitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Convert km to meters
    return earthRadiusKm * c * 1000;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Format distance for display
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
  }

  /// Check if location is within specified radius
  static bool isWithinRadius({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    required double radiusInMeters,
  }) {
    final distance = calculateDistance(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
    );

    return distance <= radiusInMeters;
  }
}