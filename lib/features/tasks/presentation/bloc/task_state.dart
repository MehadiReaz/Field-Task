import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  const TasksLoaded(
    this.tasks, {
    this.lastDocument,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [tasks, lastDocument, hasMore];
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
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  const TaskRefreshing(
    this.currentTasks, {
    this.lastDocument,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [currentTasks, lastDocument, hasMore];
}

/// Search results state
class TaskSearchResults extends TaskState {
  final List<Task> tasks;
  final String query;

  const TaskSearchResults(this.tasks, this.query);

  @override
  List<Object?> get props => [tasks, query];
}
