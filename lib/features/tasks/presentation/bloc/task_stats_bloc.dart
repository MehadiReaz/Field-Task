import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/task_stats.dart';
import '../../domain/usecases/get_task_stats.dart';
import '../../../../core/usecases/usecase.dart';

// Events
abstract class TaskStatsEvent extends Equatable {
  const TaskStatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskStatsEvent extends TaskStatsEvent {
  const LoadTaskStatsEvent();
}

class RefreshTaskStatsEvent extends TaskStatsEvent {
  const RefreshTaskStatsEvent();
}

// States
abstract class TaskStatsState extends Equatable {
  const TaskStatsState();

  @override
  List<Object?> get props => [];
}

class TaskStatsInitial extends TaskStatsState {
  const TaskStatsInitial();
}

class TaskStatsLoading extends TaskStatsState {
  const TaskStatsLoading();
}

class TaskStatsLoaded extends TaskStatsState {
  final TaskStats stats;

  const TaskStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class TaskStatsError extends TaskStatsState {
  final String message;

  const TaskStatsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class TaskStatsBloc extends Bloc<TaskStatsEvent, TaskStatsState> {
  final GetTaskStats getTaskStats;
  final CalculateAndSaveTaskStats calculateAndSaveTaskStats;

  TaskStatsBloc({
    required this.getTaskStats,
    required this.calculateAndSaveTaskStats,
  }) : super(const TaskStatsInitial()) {
    on<LoadTaskStatsEvent>(_onLoadTaskStats);
    on<RefreshTaskStatsEvent>(_onRefreshTaskStats);
  }

  Future<void> _onLoadTaskStats(
    LoadTaskStatsEvent event,
    Emitter<TaskStatsState> emit,
  ) async {
    emit(const TaskStatsLoading());
    final result = await getTaskStats(NoParams());

    result.fold(
      (failure) => emit(TaskStatsError(failure.message)),
      (stats) => emit(TaskStatsLoaded(stats)),
    );
  }

  Future<void> _onRefreshTaskStats(
    RefreshTaskStatsEvent event,
    Emitter<TaskStatsState> emit,
  ) async {
    emit(const TaskStatsLoading());
    final result = await calculateAndSaveTaskStats(NoParams());

    result.fold(
      (failure) => emit(TaskStatsError(failure.message)),
      (stats) => emit(TaskStatsLoaded(stats)),
    );
  }
}
