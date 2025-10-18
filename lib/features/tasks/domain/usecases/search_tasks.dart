import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

@injectable
class SearchTasks implements UseCase<List<Task>, SearchTasksParams> {
  final TaskRepository repository;

  SearchTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(SearchTasksParams params) async {
    final result = await repository.getTasks();

    return result.fold(
      (failure) => Left(failure),
      (tasks) {
        // Filter tasks based on search query
        final filtered = tasks.where((task) {
          final query = params.query.toLowerCase();
          final titleMatch = task.title.toLowerCase().contains(query);
          final descriptionMatch =
              task.description.toLowerCase().contains(query);
          final addressMatch =
              task.address?.toLowerCase().contains(query) ?? false;

          return titleMatch || descriptionMatch || addressMatch;
        }).toList();

        return Right(filtered);
      },
    );
  }
}

class SearchTasksParams {
  final String query;

  SearchTasksParams({required this.query});
}
