import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Load all tasks
class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

/// Load tasks filtered by status
class LoadTasksByStatusEvent extends TaskEvent {
  final String status;

  const LoadTasksByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

/// Load tasks assigned to current user
class LoadMyTasksEvent extends TaskEvent {
  final bool isRefresh;

  const LoadMyTasksEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

/// Load more tasks (for pagination)
class LoadMoreTasksEvent extends TaskEvent {
  const LoadMoreTasksEvent();

  @override
  List<Object?> get props => [];
}

/// Load a specific task by ID
class LoadTaskByIdEvent extends TaskEvent {
  final String taskId;

  const LoadTaskByIdEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Create a new task
class CreateTaskEvent extends TaskEvent {
  final Task task;

  const CreateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

/// Update an existing task
class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

/// Delete a task
class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Check in to a task (agent arrives at location)
class CheckInTaskEvent extends TaskEvent {
  final String taskId;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final String? notes;

  const CheckInTaskEvent({
    required this.taskId,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    this.notes,
  });

  @override
  List<Object?> get props => [taskId, latitude, longitude, photoUrl, notes];
}

/// Complete a task
class CompleteTaskEvent extends TaskEvent {
  final String taskId;
  final String? photoUrl;
  final String? notes;

  const CompleteTaskEvent({
    required this.taskId,
    this.photoUrl,
    this.notes,
  });

  @override
  List<Object?> get props => [taskId, photoUrl, notes];
}

/// Refresh tasks (pull to refresh)
class RefreshTasksEvent extends TaskEvent {
  const RefreshTasksEvent();
}

/// Watch tasks for real-time updates
class WatchTasksEvent extends TaskEvent {
  const WatchTasksEvent();
}

/// Search tasks by query (title/description)
class SearchTasksEvent extends TaskEvent {
  final String query;

  const SearchTasksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Clear search and return to full task list
class ClearSearchEvent extends TaskEvent {
  const ClearSearchEvent();
}
