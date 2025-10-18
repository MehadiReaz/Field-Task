import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/location_data.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/calculate_distance.dart';
import '../../domain/usecases/request_location_permission.dart';
import '../../domain/repositories/location_repository.dart';

part 'location_event.dart';
part 'location_state.dart';

@injectable
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final CalculateDistance calculateDistance;
  final RequestLocationPermission requestLocationPermission;
  final LocationRepository repository;

  LocationBloc({
    required this.getCurrentLocation,
    required this.calculateDistance,
    required this.requestLocationPermission,
    required this.repository,
  }) : super(const LocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<RequestPermissionEvent>(_onRequestPermission);
    on<CheckPermissionEvent>(_onCheckPermission);
    on<GetAddressEvent>(_onGetAddress);
    on<CalculateDistanceEvent>(_onCalculateDistance);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());

    final result = await getCurrentLocation(NoParams());

    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (location) => emit(LocationLoaded(location)),
    );
  }

  Future<void> _onRequestPermission(
    RequestPermissionEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await requestLocationPermission(NoParams());

    result.fold(
      (failure) => emit(const LocationPermissionDenied()),
      (granted) => emit(
        granted
            ? const LocationPermissionGranted()
            : const LocationPermissionDenied(),
      ),
    );
  }

  Future<void> _onCheckPermission(
    CheckPermissionEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await repository.checkLocationPermission();

    result.fold(
      (failure) => emit(const LocationPermissionDenied()),
      (granted) => emit(
        granted
            ? const LocationPermissionGranted()
            : const LocationPermissionDenied(),
      ),
    );
  }

  Future<void> _onGetAddress(
    GetAddressEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());

    final result = await repository.getAddressFromCoordinates(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (address) => emit(AddressLoaded(address)),
    );
  }

  Future<void> _onCalculateDistance(
    CalculateDistanceEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await calculateDistance(
      CalculateDistanceParams(
        startLatitude: event.startLatitude,
        startLongitude: event.startLongitude,
        endLatitude: event.endLatitude,
        endLongitude: event.endLongitude,
      ),
    );

    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (distance) => emit(DistanceCalculated(distance)),
    );
  }
}
