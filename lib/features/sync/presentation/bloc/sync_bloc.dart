import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/services/sync_service.dart';
import 'sync_event.dart';
import 'sync_state.dart';

@injectable
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncService syncService;
  DateTime? _lastSyncTime;

  SyncBloc({required this.syncService}) : super(const SyncInitial()) {
    on<StartAutoSyncEvent>(_onStartAutoSync);
    on<TriggerSyncEvent>(_onTriggerSync);
    on<GetSyncQueueCountEvent>(_onGetSyncQueueCount);
    on<StopSyncEvent>(_onStopSync);
  }

  Future<void> _onStartAutoSync(
    StartAutoSyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    syncService.startAutoSync();
    final count = await syncService.getQueueCount();
    emit(SyncIdle(pendingCount: count, lastSyncTime: _lastSyncTime));
  }

  Future<void> _onTriggerSync(
    TriggerSyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    final queueCount = await syncService.getQueueCount();

    if (queueCount == 0) {
      emit(SyncIdle(pendingCount: 0, lastSyncTime: _lastSyncTime));
      return;
    }

    emit(SyncInProgress(queueCount));

    try {
      final result = await syncService.processQueue();
      _lastSyncTime = DateTime.now();

      if (result.success) {
        emit(SyncSuccess(
          message: result.message,
          itemsSynced: result.itemsProcessed,
          timestamp: _lastSyncTime!,
        ));
      } else {
        emit(SyncError(
          message: result.message,
          itemsFailed: result.itemsFailed,
        ));
      }

      // After a brief success/error state, return to idle
      await Future.delayed(const Duration(seconds: 2));
      final newCount = await syncService.getQueueCount();
      emit(SyncIdle(pendingCount: newCount, lastSyncTime: _lastSyncTime));
    } catch (e) {
      emit(SyncError(
        message: 'Sync failed: ${e.toString()}',
        itemsFailed: queueCount,
      ));

      // Return to idle after error
      await Future.delayed(const Duration(seconds: 2));
      final newCount = await syncService.getQueueCount();
      emit(SyncIdle(pendingCount: newCount, lastSyncTime: _lastSyncTime));
    }
  }

  Future<void> _onGetSyncQueueCount(
    GetSyncQueueCountEvent event,
    Emitter<SyncState> emit,
  ) async {
    final count = await syncService.getQueueCount();
    final isSyncing = syncService.isSyncing;

    emit(SyncQueueStatus(
      pendingCount: count,
      isSyncing: isSyncing,
    ));
  }

  Future<void> _onStopSync(
    StopSyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    syncService.dispose();
    emit(const SyncInitial());
  }

  @override
  Future<void> close() {
    syncService.dispose();
    return super.close();
  }
}
