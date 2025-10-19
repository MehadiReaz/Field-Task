import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/get_tasks_page.dart';
import '../../domain/usecases/get_task_by_id.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/check_in_task.dart';
import '../../domain/usecases/checkout_task.dart';
import '../../domain/usecases/complete_task.dart';
import '../../domain/usecases/search_tasks.dart';
import 'task_event.dart';
import 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final GetTasksPage getTasksPage;
  final GetTaskById getTaskById;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final CheckInTask checkInTask;
  final CheckoutTask checkoutTask;
  final CompleteTask completeTask;
  final SearchTasks searchTasks;

  TaskBloc({
    required this.getTasks,
    required this.getTasksPage,
    required this.getTaskById,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.checkInTask,
    required this.checkoutTask,
    required this.completeTask,
    required this.searchTasks,
  }) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTasksByStatusEvent>(_onLoadTasksByStatus);
    on<LoadMyTasksEvent>(_onLoadMyTasks);
    on<LoadMoreTasksEvent>(_onLoadMoreTasks);
    on<LoadTaskByIdEvent>(_onLoadTaskById);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<CheckInTaskEvent>(_onCheckInTask);
    on<CheckoutTaskEvent>(_onCheckoutTask);
    on<CompleteTaskEvent>(_onCompleteTask);
    on<RefreshTasksEvent>(_onRefreshTasks);
    on<SearchTasksEvent>(_onSearchTasks);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await getTasks(NoParams());

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) {
        if (tasks.isEmpty) {
          emit(const TasksEmpty());
        } else {
          emit(TasksLoaded(tasks));
        }
      },
    );
  }

  Future<void> _onLoadTasksByStatus(
    LoadTasksByStatusEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    // For now, get all tasks and filter client-side
    // TODO: Add status filter to repository
    final result = await getTasks(NoParams());

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (allTasks) {
        // Convert status string to TaskStatus enum for comparison
        final filteredTasks = allTasks
            .where((task) =>
                task.status.value == event.status ||
                task.status.toString().split('.').last == event.status)
            .toList();

        if (filteredTasks.isEmpty) {
          emit(const TasksEmpty());
        } else {
          emit(TasksLoaded(filteredTasks));
        }
      },
    );
  }

  Future<void> _onLoadMyTasks(
    LoadMyTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    // If refreshing, reset pagination
    if (event.isRefresh) {
      emit(const TaskLoading());
    } else if (state is! TasksLoaded) {
      // If loading for the first time
      emit(const TaskLoading());
    }

    final result = await getTasksPage(GetTasksPageParams(
      lastDocument: null, // First page
      pageSize: 10,
    ));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (taskPage) {
        if (taskPage.tasks.isEmpty) {
          emit(const TasksEmpty());
        } else {
          emit(TasksLoaded(
            taskPage.tasks,
            lastDocument: taskPage.lastDocument,
            hasMore: taskPage.hasMore,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMoreTasks(
    LoadMoreTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;

    // Only load more if we're already in TasksLoaded state and hasMore is true
    if (currentState is! TasksLoaded) return;
    if (!currentState.hasMore) return;

    final currentTasks = currentState.tasks;
    final lastDocument = currentState.lastDocument;

    final result = await getTasksPage(GetTasksPageParams(
      lastDocument: lastDocument,
      pageSize: 10,
    ));

    result.fold(
      (failure) {
        // Keep showing current tasks, just log the error
        print('❌ Error loading more tasks: $failure');
      },
      (taskPage) {
        // Append new tasks to existing ones
        final allTasks = [...currentTasks, ...taskPage.tasks];
        emit(TasksLoaded(
          allTasks,
          lastDocument: taskPage.lastDocument,
          hasMore: taskPage.hasMore,
        ));
      },
    );
  }

  Future<void> _onLoadTaskById(
    LoadTaskByIdEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await getTaskById(GetTaskByIdParams(event.taskId));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (task) => emit(TaskLoaded(task)),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await createTask(CreateTaskParams(event.task));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(const TaskOperationSuccess('Task created successfully')),
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await updateTask(UpdateTaskParams(event.task));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(const TaskOperationSuccess('Task updated successfully')),
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await deleteTask(DeleteTaskParams(event.taskId));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(const TaskOperationSuccess('Task deleted successfully')),
    );
  }

  Future<void> _onCheckInTask(
    CheckInTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await checkInTask(CheckInTaskParams(
      id: event.taskId,
      latitude: event.latitude,
      longitude: event.longitude,
      photoUrl: event.photoUrl,
    ));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(const TaskOperationSuccess('Checked in successfully')),
    );
  }

  Future<void> _onCheckoutTask(
    CheckoutTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await checkoutTask(CheckoutTaskParams(id: event.taskId));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(const TaskOperationSuccess(
          'Checked out successfully - task removed from list')),
    );
  }

  Future<void> _onCompleteTask(
    CompleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await completeTask(CompleteTaskParams(
      id: event.taskId,
      completionNotes: event.notes,
      photoUrl: event.photoUrl,
    ));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(const TaskOperationSuccess('Task completed successfully')),
    );
  }

  Future<void> _onRefreshTasks(
    RefreshTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Keep current tasks while refreshing
    final currentTasks =
        state is TasksLoaded ? (state as TasksLoaded).tasks : <dynamic>[];

    emit(TaskRefreshing(currentTasks.cast()));

    final result = await getTasks(NoParams());

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) {
        if (tasks.isEmpty) {
          emit(const TasksEmpty());
        } else {
          emit(TasksLoaded(tasks));
        }
      },
    );
  }

  Future<void> _onSearchTasks(
    SearchTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    // If query is empty, just load all tasks
    if (event.query.isEmpty) {
      final result = await getTasks(NoParams());

      result.fold(
        (failure) => emit(TaskError(failure.message)),
        (tasks) {
          if (tasks.isEmpty) {
            emit(const TasksEmpty());
          } else {
            emit(TasksLoaded(tasks));
          }
        },
      );
      return;
    }

    // Don't show loading if we already have tasks (for better UX during typing)
    if (state is! TasksLoaded) {
      emit(const TaskLoading());
    }

    // Perform search
    final result = await searchTasks(SearchTasksParams(
      query: event.query,
      searchFields: const ['title', 'description'],
    ));

    result.fold(
      (failure) {
        print('❌ Search failed: ${failure.message}');
        emit(TaskError(failure.message));
      },
      (tasks) {
        if (tasks.isEmpty) {
          emit(const TasksEmpty());
        } else {
          emit(TasksLoaded(tasks));
        }
      },
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Just reload all tasks
    final result = await getTasks(NoParams());

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) {
        if (tasks.isEmpty) {
          emit(const TasksEmpty());
        } else {
          emit(TasksLoaded(tasks));
        }
      },
    );
  }
}
