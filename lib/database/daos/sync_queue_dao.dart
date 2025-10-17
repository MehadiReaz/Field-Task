import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(AppDatabase db) : super(db);

  // Get all pending sync items
  Future<List<SyncQueueEntity>> getPendingSyncItems() {
    return (select(syncQueue)
      ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
  }

  // Add to sync queue
  Future<void> addToQueue(SyncQueueCompanion item) {
    return into(syncQueue).insert(item);
  }

  // Remove from queue
  Future<int> removeFromQueue(String id) {
    return (delete(syncQueue)..where((t) => t.id.equals(id))).go();
  }

  // Update retry count
  Future<void> incrementRetryCount(String id) async {
    final item = await (select(syncQueue)..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (item != null) {
      await (update(syncQueue)..where((t) => t.id.equals(id))).write(
        SyncQueueCompanion(
          retryCount: Value(item.retryCount + 1),
          lastRetryAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // Clear all synced items
  Future<int> clearQueue() {
    return delete(syncQueue).go();
  }

  // Get queue count
  Future<int> getQueueCount() async {
    final result = await (selectOnly(syncQueue)
      ..addColumns([syncQueue.id.count()]))
        .getSingle();
    return result.read(syncQueue.id.count()) ?? 0;
  }
}