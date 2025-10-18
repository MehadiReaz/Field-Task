import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

/// Model representing a paginated response of tasks from Firestore
class TaskPageModel {
  final List<TaskModel> tasks;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  TaskPageModel({
    required this.tasks,
    this.lastDocument,
    required this.hasMore,
  });

  factory TaskPageModel.empty() {
    return TaskPageModel(
      tasks: [],
      lastDocument: null,
      hasMore: false,
    );
  }

  /// Create a TaskPageModel from a Firestore query snapshot
  factory TaskPageModel.fromQuerySnapshot(
    QuerySnapshot snapshot, {
    required int pageSize,
  }) {
    final tasks = snapshot.docs
        .map((doc) =>
            TaskModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();

    // hasMore is true if we got a full page of results
    // (meaning there might be more documents to fetch)
    final hasMore = tasks.length >= pageSize;

    // lastDocument is the last document in the current batch
    final lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return TaskPageModel(
      tasks: tasks,
      lastDocument: lastDocument,
      hasMore: hasMore,
    );
  }

  /// Copy with new values
  TaskPageModel copyWith({
    List<TaskModel>? tasks,
    DocumentSnapshot? lastDocument,
    bool? hasMore,
  }) {
    return TaskPageModel(
      tasks: tasks ?? this.tasks,
      lastDocument: lastDocument ?? this.lastDocument,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
