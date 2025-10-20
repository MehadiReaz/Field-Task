import 'package:injectable/injectable.dart';
import '../../../../database/database.dart';

abstract class SyncDataSource {
  Future<List<SyncQueueEntity>> getPendingSyncItems();
  Future<void> addToQueue(String taskId, String operation, String payload);
  Future<void> removeFromQueue(String id);
  Future<void> incrementRetryCount(String id);
  Future<int> getQueueCount();
}

@LazySingleton(as: SyncDataSource)
class SyncDataSourceImpl implements SyncDataSource {
  final AppDatabase database;

  SyncDataSourceImpl(this.database);

  @override
  Future<List<SyncQueueEntity>> getPendingSyncItems() {
    return database.syncQueueDao.getPendingSyncItems();
  }

  @override
  Future<void> addToQueue(
      String taskId, String operation, String payload) async {
    await database.syncQueueDao.addToQueue(
      SyncQueueCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        taskId: taskId,
        operation: operation,
        payload: payload,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> removeFromQueue(String id) async {
    await database.syncQueueDao.removeFromQueue(id);
  }

  @override
  Future<void> incrementRetryCount(String id) async {
    await database.syncQueueDao.incrementRetryCount(id);
  }

  @override
  Future<int> getQueueCount() {
    return database.syncQueueDao.getQueueCount();
  }
}
