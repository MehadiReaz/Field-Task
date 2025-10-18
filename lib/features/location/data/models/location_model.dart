import '../../domain/entities/location_data.dart';

class LocationModel extends LocationData {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.address,
    super.accuracy,
    required super.timestamp,
  });

  factory LocationModel.fromEntity(LocationData entity) {
    return LocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      accuracy: entity.accuracy,
      timestamp: entity.timestamp,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      accuracy: json['accuracy'] != null
          ? (json['accuracy'] as num).toDouble()
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
