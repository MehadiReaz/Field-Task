import 'package:equatable/equatable.dart';

abstract class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SyncInitial extends SyncState {
  const SyncInitial();
}

/// Syncing in progress
class SyncInProgress extends SyncState {
  final int queueCount;
  final double? progress; // 0.0 to 1.0
  final int? itemsProcessed;

  const SyncInProgress(
    this.queueCount, {
    this.progress,
    this.itemsProcessed,
  });

  @override
  List<Object?> get props => [queueCount, progress, itemsProcessed];
}

/// Sync completed successfully
class SyncSuccess extends SyncState {
  final String message;
  final int itemsSynced;
  final DateTime timestamp;

  const SyncSuccess({
    required this.message,
    required this.itemsSynced,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [message, itemsSynced, timestamp];
}

/// Sync failed with error
class SyncError extends SyncState {
  final String message;
  final int itemsFailed;
  final bool canRetry;

  const SyncError({
    required this.message,
    required this.itemsFailed,
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [message, itemsFailed, canRetry];
}

/// Sync queue status
class SyncQueueStatus extends SyncState {
  final int pendingCount;
  final bool isSyncing;

  const SyncQueueStatus({
    required this.pendingCount,
    required this.isSyncing,
  });

  @override
  List<Object?> get props => [pendingCount, isSyncing];
}

/// Idle state (no sync activity)
class SyncIdle extends SyncState {
  final int pendingCount;
  final DateTime? lastSyncTime;

  const SyncIdle({
    required this.pendingCount,
    this.lastSyncTime,
  });

  @override
  List<Object?> get props => [pendingCount, lastSyncTime];
}
