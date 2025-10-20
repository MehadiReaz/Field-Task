import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/theme_repository.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class SetThemeModeEvent extends ThemeEvent {
  final ThemeMode mode;

  const SetThemeModeEvent(this.mode);

  @override
  List<Object> get props => [mode];
}

// States
class ThemeState extends Equatable {
  final ThemeMode mode;

  const ThemeState(this.mode);

  @override
  List<Object> get props => [mode];
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _repo;

  ThemeBloc(this._repo) : super(_getInitialState(_repo)) {
    on<SetThemeModeEvent>(_onSetThemeMode);
  }

  static ThemeState _getInitialState(ThemeRepository repo) {
    final stored = repo.getThemeMode();
    ThemeMode initialMode = ThemeMode.system;
    if (stored == 'light')
      initialMode = ThemeMode.light;
    else if (stored == 'dark') initialMode = ThemeMode.dark;
    return ThemeState(initialMode);
  }

  Future<void> _onSetThemeMode(
      SetThemeModeEvent event, Emitter<ThemeState> emit) async {
    final val = event.mode == ThemeMode.light
        ? 'light'
        : event.mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await _repo.saveThemeMode(val);
    emit(ThemeState(event.mode));
  }
}
