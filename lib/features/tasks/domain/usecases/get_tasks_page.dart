import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../models/task_page.dart';
import '../repositories/task_repository.dart';

@injectable
class GetTasksPage implements UseCase<TaskPage, GetTasksPageParams> {
  final TaskRepository repository;

  GetTasksPage(this.repository);

  @override
  Future<Either<Failure, TaskPage>> call(GetTasksPageParams params) async {
    return await repository.getTasksPage(
      lastDocument: params.lastDocument,
      pageSize: params.pageSize,
    );
  }
}

class GetTasksPageParams extends Equatable {
  final DocumentSnapshot? lastDocument;
  final int pageSize;

  const GetTasksPageParams({
    this.lastDocument,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [lastDocument, pageSize];
}
