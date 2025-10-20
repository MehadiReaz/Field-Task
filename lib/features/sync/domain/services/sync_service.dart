import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../database/database.dart';
import '../../../tasks/data/datasources/task_remote_datasource.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../data/datasources/sync_datasource.dart';

@lazySingleton
class SyncService {
  final SyncDataSource syncDataSource;
  final TaskRemoteDataSource taskRemoteDataSource;
  final ConnectivityService connectivityService;

  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncService({
    required this.syncDataSource,
    required this.taskRemoteDataSource,
    required this.connectivityService,
  });

  /// Start listening to connectivity changes and auto-sync
  void startAutoSync() {
    _connectivitySubscription =
        connectivityService.statusStream.listen((status) {
      if (status == ConnectivityStatus.online && !_isSyncing) {
        processQueue();
      }
    });

    // Periodic sync every 5 minutes when online
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (await connectivityService.isConnected() && !_isSyncing) {
        processQueue();
      }
    });
  }

  /// Process all pending sync items in the queue
  Future<SyncResult> processQueue({
    void Function(int processed, int total)? onProgress,
  }) async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        itemsProcessed: 0,
        itemsFailed: 0,
        message: 'Sync already in progress',
        canRetry: false,
      );
    }

    _isSyncing = true;
    int processed = 0;
    int failed = 0;

    try {
      final items = await syncDataSource.getPendingSyncItems();

      if (items.isEmpty) {
        _isSyncing = false;
        return SyncResult(
          success: true,
          itemsProcessed: 0,
          itemsFailed: 0,
          message: 'No items to sync',
          canRetry: false,
        );
      }

      final total = items.length;

      for (final item in items) {
        try {
          await _processSyncItem(item);
          await syncDataSource.removeFromQueue(item.id);
          processed++;

          // Report progress
          onProgress?.call(processed, total);
        } catch (e) {
          failed++;

          // Increment retry count
          await syncDataSource.incrementRetryCount(item.id);

          // If retried more than 3 times, remove from queue
          if (item.retryCount >= 3) {
            await syncDataSource.removeFromQueue(item.id);
          }
        }
      }

      _isSyncing = false;
      return SyncResult(
        success: failed == 0,
        itemsProcessed: processed,
        itemsFailed: failed,
        message: failed == 0
            ? 'Successfully synced $processed ${processed == 1 ? 'item' : 'items'}'
            : 'Synced $processed ${processed == 1 ? 'item' : 'items'}, $failed failed',
        canRetry: failed > 0,
      );
    } catch (e) {
      _isSyncing = false;
      return SyncResult(
        success: false,
        itemsProcessed: processed,
        itemsFailed: failed,
        message: 'Sync error: ${e.toString()}',
        canRetry: true,
      );
    }
  }

  Future<void> _processSyncItem(SyncQueueEntity item) async {
    final payload = json.decode(item.payload) as Map<String, dynamic>;

    switch (item.operation) {
      case 'create':
      case 'update':
        // For create/update, payload contains full task data
        final task = TaskModel.fromFirestore(payload);
        if (item.operation == 'create') {
          await taskRemoteDataSource.createTask(task);
        } else {
          await taskRemoteDataSource.updateTask(task);
        }
        break;
      case 'delete':
        await taskRemoteDataSource.deleteTask(item.taskId);
        break;
      case 'check_in':
        // For check_in, payload contains specific check-in fields
        await taskRemoteDataSource.checkInTask(
          payload['taskId'] ?? item.taskId,
          payload['locationLat'],
          payload['locationLng'],
          payload['checkInPhotoUrl'],
        );
        break;
      case 'complete':
        // For complete, payload contains specific completion fields
        await taskRemoteDataSource.completeTask(
          payload['taskId'] ?? item.taskId,
          payload['completionNotes'],
          payload['completionPhotoUrl'],
        );
        break;
    }
  }

  /// Get current sync queue count
  Future<int> getQueueCount() {
    return syncDataSource.getQueueCount();
  }

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;

  /// Stop auto-sync
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
  }
}

class SyncResult {
  final bool success;
  final int itemsProcessed;
  final int itemsFailed;
  final String message;
  final bool canRetry;

  SyncResult({
    required this.success,
    required this.itemsProcessed,
    required this.itemsFailed,
    required this.message,
    this.canRetry = true,
  });
}
