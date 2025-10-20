import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/tasks_table.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  // Get all tasks for a user
  Stream<List<TaskEntity>> watchTasksByUserId(String userId) {
    return (select(tasks)
          ..where((t) => t.assignedToId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.dueDateTime)]))
        .watch();
  }

  // Get tasks with pagination
  Future<List<TaskEntity>> getTasksPaginated({
    required String userId,
    required int limit,
    required int offset,
    String? status,
  }) {
    final query = select(tasks)..where((t) => t.assignedToId.equals(userId));

    if (status != null && status != 'all') {
      query.where((t) => t.status.equals(status));
    }

    query
      ..orderBy([(t) => OrderingTerm.desc(t.dueDateTime)])
      ..limit(limit, offset: offset);

    return query.get();
  }

  // Get task by ID
  Future<TaskEntity?> getTaskById(String id) {
    return (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Search tasks
  Future<List<TaskEntity>> searchTasks(String userId, String query) {
    return (select(tasks)
          ..where((t) =>
              t.assignedToId.equals(userId) &
              (t.title.contains(query) | t.description.contains(query))))
        .get();
  }

  // Insert task
  Future<int> insertTask(TasksCompanion task) {
    return into(tasks).insertOnConflictUpdate(task);
  }

  // Update task
  Future<bool> updateTask(TaskEntity task) {
    return update(tasks).replace(task);
  }

  // Delete task
  Future<int> deleteTask(String id) {
    return (delete(tasks)..where((t) => t.id.equals(id))).go();
  }

  // Get pending sync tasks
  Future<List<TaskEntity>> getPendingSyncTasks() {
    return (select(tasks)..where((t) => t.syncStatus.equals('pending'))).get();
  }

  // Update sync status
  Future<void> updateSyncStatus(String id, String status) {
    return (update(tasks)..where((t) => t.id.equals(id)))
        .write(TasksCompanion(syncStatus: Value(status)));
  }

  // Get task count by status
  Future<int> getTaskCount(String userId, String status) async {
    final query = selectOnly(tasks)
      ..addColumns([tasks.id.count()])
      ..where(tasks.assignedToId.equals(userId));

    if (status != 'all') {
      query.where(tasks.status.equals(status));
    }

    final result = await query.getSingle();
    return result.read(tasks.id.count()) ?? 0;
  }
}
