part of 'area_bloc.dart';

abstract class AreaEvent extends Equatable {
  const AreaEvent();

  @override
  List<Object?> get props => [];
}

class LoadAreasEvent extends AreaEvent {
  const LoadAreasEvent();
}

class LoadAreaByIdEvent extends AreaEvent {
  final String id;

  const LoadAreaByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateAreaEvent extends AreaEvent {
  final Area area;

  const CreateAreaEvent(this.area);

  @override
  List<Object?> get props => [area];
}

class UpdateAreaEvent extends AreaEvent {
  final Area area;

  const UpdateAreaEvent(this.area);

  @override
  List<Object?> get props => [area];
}

class DeleteAreaEvent extends AreaEvent {
  final String id;

  const DeleteAreaEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CheckLocationInAreaEvent extends AreaEvent {
  final String areaId;
  final double latitude;
  final double longitude;

  const CheckLocationInAreaEvent({
    required this.areaId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [areaId, latitude, longitude];
}
