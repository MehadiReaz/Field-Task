part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final LocationData location;

  const LocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class LocationPermissionGranted extends LocationState {
  const LocationPermissionGranted();
}

class LocationPermissionDenied extends LocationState {
  const LocationPermissionDenied();
}

class AddressLoaded extends LocationState {
  final String address;

  const AddressLoaded(this.address);

  @override
  List<Object?> get props => [address];
}

class DistanceCalculated extends LocationState {
  final double distance;

  const DistanceCalculated(this.distance);

  @override
  List<Object?> get props => [distance];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
