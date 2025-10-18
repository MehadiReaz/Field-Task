import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@injectable
class FilterTasks implements UseCase<List<Task>, FilterTasksParams> {
  final TaskRepository repository;

  FilterTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(FilterTasksParams params) async {
    final result = await repository.getTasks();

    return result.fold(
      (failure) => Left(failure),
      (tasks) {
        var filtered = tasks;

        // Filter by status
        if (params.status != null) {
          filtered =
              filtered.where((task) => task.status == params.status).toList();
        }

        // Filter by priority
        if (params.priority != null) {
          filtered = filtered
              .where((task) => task.priority == params.priority)
              .toList();
        }

        // Filter by assigned user
        if (params.assignedToId != null) {
          filtered = filtered
              .where((task) => task.assignedToId == params.assignedToId)
              .toList();
        }

        // Filter by date range
        if (params.startDate != null) {
          filtered = filtered
              .where((task) => task.dueDateTime.isAfter(params.startDate!))
              .toList();
        }

        if (params.endDate != null) {
          filtered = filtered
              .where((task) => task.dueDateTime.isBefore(params.endDate!))
              .toList();
        }

        // Filter by overdue
        if (params.showOverdueOnly == true) {
          final now = DateTime.now();
          filtered = filtered.where((task) {
            return task.status != TaskStatus.completed &&
                task.dueDateTime.isBefore(now);
          }).toList();
        }

        // Sort by due date
        if (params.sortByDueDate == true) {
          filtered.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
        }

        // Sort by priority
        if (params.sortByPriority == true) {
          filtered.sort((a, b) => b.priority.value.compareTo(a.priority.value));
        }

        return Right(filtered);
      },
    );
  }
}

class FilterTasksParams {
  final TaskStatus? status;
  final TaskPriority? priority;
  final String? assignedToId;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? showOverdueOnly;
  final bool? sortByDueDate;
  final bool? sortByPriority;

  FilterTasksParams({
    this.status,
    this.priority,
    this.assignedToId,
    this.startDate,
    this.endDate,
    this.showOverdueOnly,
    this.sortByDueDate,
    this.sortByPriority,
  });
}
