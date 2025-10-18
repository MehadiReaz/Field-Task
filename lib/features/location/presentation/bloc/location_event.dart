part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentLocationEvent extends LocationEvent {
  const GetCurrentLocationEvent();
}

class RequestPermissionEvent extends LocationEvent {
  const RequestPermissionEvent();
}

class CheckPermissionEvent extends LocationEvent {
  const CheckPermissionEvent();
}

class GetAddressEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  const GetAddressEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class CalculateDistanceEvent extends LocationEvent {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  const CalculateDistanceEvent({
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });

  @override
  List<Object?> get props => [
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      ];
}
