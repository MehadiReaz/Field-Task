import 'dart:async';
import 'package:dartz/dartz.dart' as dartz;
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
import '../../domain/entities/task.dart';
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

  // Helper method to handle common task list result pattern
  void _emitTaskListResult(
    Emitter<TaskState> emit,
    dartz.Either<dynamic, List<Task>> result,
  ) {
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(tasks.isEmpty ? const TasksEmpty() : TasksLoaded(tasks)),
    );
  }

  // Helper method to handle operation success
  void _emitOperationResult(
    Emitter<TaskState> emit,
    dartz.Either<dynamic, dynamic> result,
    String successMessage,
  ) {
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => emit(TaskOperationSuccess(successMessage)),
    );
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    final result = await getTasks(const NoParams());
    _emitTaskListResult(emit, result);
  }

  Future<void> _onLoadTasksByStatus(
    LoadTasksByStatusEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await getTasksPage(GetTasksPageParams(
      lastDocument: null,
      pageSize: 10,
      status: event.status,
      showExpiredOnly: false,
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

  Future<void> _onLoadMyTasks(
    LoadMyTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (event.isRefresh || state is! TasksLoaded) {
      emit(const TaskLoading());
    }

    final result = await getTasksPage(GetTasksPageParams(
      lastDocument: null,
      pageSize: 10,
      status: event.status,
      showExpiredOnly: event.showExpiredOnly,
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
    if (state is! TasksLoaded) return;

    final currentState = state as TasksLoaded;
    if (!currentState.hasMore) return;

    final result = await getTasksPage(GetTasksPageParams(
      lastDocument: currentState.lastDocument,
      pageSize: 10,
      status: event.status,
      showExpiredOnly: event.showExpiredOnly,
    ));

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (taskPage) {
        emit(TasksLoaded(
          [...currentState.tasks, ...taskPage.tasks],
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
    _emitOperationResult(emit, result, 'Task created successfully');
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    final result = await updateTask(UpdateTaskParams(event.task));
    _emitOperationResult(emit, result, 'Task updated successfully');
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    final result = await deleteTask(DeleteTaskParams(event.taskId));
    _emitOperationResult(emit, result, 'Task deleted successfully');
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

    _emitOperationResult(emit, result, 'Checked in successfully');
  }

  Future<void> _onCheckoutTask(
    CheckoutTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    final result = await checkoutTask(CheckoutTaskParams(id: event.taskId));
    _emitOperationResult(
      emit,
      result,
      'Checked out successfully - task removed from list',
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

    _emitOperationResult(emit, result, 'Task completed successfully');
  }

  Future<void> _onRefreshTasks(
    RefreshTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TasksLoaded) {
      emit(TaskRefreshing((state as TasksLoaded).tasks));
    }

    final result = await getTasks(const NoParams());
    _emitTaskListResult(emit, result);
  }

  Future<void> _onSearchTasks(
    SearchTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is! TasksLoaded) {
      emit(const TaskLoading());
    }

    final result = event.query.isEmpty
        ? await getTasks(const NoParams())
        : await searchTasks(SearchTasksParams(
            query: event.query,
            searchFields: const ['title', 'description'],
          ));

    _emitTaskListResult(emit, result);
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await getTasks(const NoParams());
    _emitTaskListResult(emit, result);
  }
}
