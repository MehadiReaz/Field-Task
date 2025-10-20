import 'package:equatable/equatable.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

/// Start automatic sync monitoring
class StartAutoSyncEvent extends SyncEvent {
  const StartAutoSyncEvent();
}

/// Manual sync trigger
class TriggerSyncEvent extends SyncEvent {
  const TriggerSyncEvent();
}

/// Get sync queue count
class GetSyncQueueCountEvent extends SyncEvent {
  const GetSyncQueueCountEvent();
}

/// Stop sync monitoring
class StopSyncEvent extends SyncEvent {
  const StopSyncEvent();
}
