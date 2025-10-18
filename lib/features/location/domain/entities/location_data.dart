import 'package:equatable/equatable.dart';

class LocationData extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final double? accuracy;
  final DateTime timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.accuracy,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        address,
        accuracy,
        timestamp,
      ];

  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? address,
    double? accuracy,
    DateTime? timestamp,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
