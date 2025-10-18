part of 'area_bloc.dart';

abstract class AreaState extends Equatable {
  const AreaState();

  @override
  List<Object?> get props => [];
}

class AreaInitial extends AreaState {
  const AreaInitial();
}

class AreaLoading extends AreaState {
  const AreaLoading();
}

class AreasLoaded extends AreaState {
  final List<Area> areas;

  const AreasLoaded(this.areas);

  @override
  List<Object?> get props => [areas];
}

class AreaLoaded extends AreaState {
  final Area area;

  const AreaLoaded(this.area);

  @override
  List<Object?> get props => [area];
}

class AreaCreated extends AreaState {
  final Area area;

  const AreaCreated(this.area);

  @override
  List<Object?> get props => [area];
}

class AreaUpdated extends AreaState {
  final Area area;

  const AreaUpdated(this.area);

  @override
  List<Object?> get props => [area];
}

class AreaDeleted extends AreaState {
  const AreaDeleted();
}

class LocationInAreaChecked extends AreaState {
  final bool isInArea;

  const LocationInAreaChecked(this.isInArea);

  @override
  List<Object?> get props => [isInArea];
}

class AreaError extends AreaState {
  final String message;

  const AreaError(this.message);

  @override
  List<Object?> get props => [message];
}
