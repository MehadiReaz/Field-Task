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

  const SyncInProgress(this.queueCount);

  @override
  List<Object?> get props => [queueCount];
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

  const SyncError({
    required this.message,
    required this.itemsFailed,
  });

  @override
  List<Object?> get props => [message, itemsFailed];
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
