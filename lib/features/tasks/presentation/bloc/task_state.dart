import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TaskInitial extends TaskState {
  const TaskInitial();
}

/// Loading state
class TaskLoading extends TaskState {
  const TaskLoading();
}

/// Tasks loaded successfully
class TasksLoaded extends TaskState {
  final List<Task> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

/// Single task loaded successfully
class TaskLoaded extends TaskState {
  final Task task;

  const TaskLoaded(this.task);

  @override
  List<Object?> get props => [task];
}

/// Task operation successful (create, update, delete, check-in, complete)
class TaskOperationSuccess extends TaskState {
  final String message;

  const TaskOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state (no tasks found)
class TasksEmpty extends TaskState {
  const TasksEmpty();
}

/// Refreshing state (pull to refresh)
class TaskRefreshing extends TaskState {
  final List<Task> currentTasks;

  const TaskRefreshing(this.currentTasks);

  @override
  List<Object?> get props => [currentTasks];
}
