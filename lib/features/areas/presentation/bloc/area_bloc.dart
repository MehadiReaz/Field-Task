import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/area.dart';
import '../../domain/usecases/create_area.dart';
import '../../domain/usecases/delete_area.dart';
import '../../domain/usecases/get_area_by_id.dart';
import '../../domain/usecases/get_areas.dart';
import '../../domain/usecases/update_area.dart';
import '../../domain/usecases/check_location_in_area.dart';

part 'area_event.dart';
part 'area_state.dart';

@injectable
class AreaBloc extends Bloc<AreaEvent, AreaState> {
  final GetAreas getAreas;
  final GetAreaById getAreaById;
  final CreateArea createArea;
  final UpdateArea updateArea;
  final DeleteArea deleteArea;
  final CheckLocationInArea checkLocationInArea;

  AreaBloc({
    required this.getAreas,
    required this.getAreaById,
    required this.createArea,
    required this.updateArea,
    required this.deleteArea,
    required this.checkLocationInArea,
  }) : super(const AreaInitial()) {
    on<LoadAreasEvent>(_onLoadAreas);
    on<LoadAreaByIdEvent>(_onLoadAreaById);
    on<CreateAreaEvent>(_onCreateArea);
    on<UpdateAreaEvent>(_onUpdateArea);
    on<DeleteAreaEvent>(_onDeleteArea);
    on<CheckLocationInAreaEvent>(_onCheckLocationInArea);
  }

  Future<void> _onLoadAreas(
    LoadAreasEvent event,
    Emitter<AreaState> emit,
  ) async {
    emit(const AreaLoading());

    final result = await getAreas(NoParams());

    result.fold(
      (failure) => emit(AreaError(failure.message)),
      (areas) => emit(AreasLoaded(areas)),
    );
  }

  Future<void> _onLoadAreaById(
    LoadAreaByIdEvent event,
    Emitter<AreaState> emit,
  ) async {
    emit(const AreaLoading());

    final result = await getAreaById(GetAreaByIdParams(id: event.id));

    result.fold(
      (failure) => emit(AreaError(failure.message)),
      (area) => emit(AreaLoaded(area)),
    );
  }

  Future<void> _onCreateArea(
    CreateAreaEvent event,
    Emitter<AreaState> emit,
  ) async {
    emit(const AreaLoading());

    final result = await createArea(CreateAreaParams(area: event.area));

    result.fold(
      (failure) => emit(AreaError(failure.message)),
      (area) => emit(AreaCreated(area)),
    );
  }

  Future<void> _onUpdateArea(
    UpdateAreaEvent event,
    Emitter<AreaState> emit,
  ) async {
    emit(const AreaLoading());

    final result = await updateArea(UpdateAreaParams(area: event.area));

    result.fold(
      (failure) => emit(AreaError(failure.message)),
      (area) => emit(AreaUpdated(area)),
    );
  }

  Future<void> _onDeleteArea(
    DeleteAreaEvent event,
    Emitter<AreaState> emit,
  ) async {
    emit(const AreaLoading());

    final result = await deleteArea(DeleteAreaParams(id: event.id));

    result.fold(
      (failure) => emit(AreaError(failure.message)),
      (_) => emit(const AreaDeleted()),
    );
  }

  Future<void> _onCheckLocationInArea(
    CheckLocationInAreaEvent event,
    Emitter<AreaState> emit,
  ) async {
    final result = await checkLocationInArea(
      CheckLocationInAreaParams(
        areaId: event.areaId,
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );

    result.fold(
      (failure) => emit(AreaError(failure.message)),
      (isInArea) => emit(LocationInAreaChecked(isInArea)),
    );
  }
}
