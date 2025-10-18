import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../entities/task.dart';

/// Domain model representing a paginated list of tasks
class TaskPage extends Equatable {
  final List<Task> tasks;
  final bool hasMore;
  final DocumentSnapshot?
      lastDocument; // Firestore document for cursor-based pagination

  const TaskPage({
    required this.tasks,
    required this.hasMore,
    this.lastDocument,
  });

  @override
  List<Object?> get props => [tasks, hasMore, lastDocument];
}
