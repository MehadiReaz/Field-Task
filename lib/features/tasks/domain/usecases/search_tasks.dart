import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
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
    // Empty query returns all tasks (via getTasks)
    if (params.query.isEmpty) {
      return await repository.getTasks();
    }

    // Try server-based search first (if online)
    if (!params.useLocalDatabase) {
      final serverResult = await repository.searchTasks(
        query: params.query,
        searchFields: params.searchFields,
      );

      // If server search successful, return
      if (serverResult.fold((l) => false, (r) => true)) {
        return serverResult;
      }

      // If server fails, fall back to local database
      print('⚠️ Server search failed, falling back to local database');
    }

    // Search local database (offline fallback)
    final localResult = await repository.searchTasksLocal(
      query: params.query,
      searchFields: params.searchFields,
    );

    return localResult;
  }
}

class SearchTasksParams extends Equatable {
  final String query;
  final List<String> searchFields; // e.g., ['title', 'description']
  final bool useLocalDatabase; // If true, force local db search

  const SearchTasksParams({
    required this.query,
    this.searchFields = const ['title', 'description'],
    this.useLocalDatabase = false,
  });

  @override
  List<Object?> get props => [query, searchFields, useLocalDatabase];
}
