import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vibration/vibration.dart';
import '../../domain/services/sync_service.dart';
import 'sync_event.dart';
import 'sync_state.dart';

@injectable
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncService syncService;
  DateTime? _lastSyncTime;
  DateTime? _lastSyncTrigger;
  static const _syncDebounceTime = Duration(seconds: 2);

  SyncBloc({required this.syncService}) : super(const SyncInitial()) {
    on<StartAutoSyncEvent>(_onStartAutoSync);
    on<TriggerSyncEvent>(_onTriggerSync, transformer: _debounceTransformer());
    on<GetSyncQueueCountEvent>(_onGetSyncQueueCount);
    on<StopSyncEvent>(_onStopSync);
  }

  /// Debounce transformer to prevent rapid sync triggers
  EventTransformer<TriggerSyncEvent> _debounceTransformer() {
    return (events, mapper) {
      return events.where((event) {
        final now = DateTime.now();
        if (_lastSyncTrigger == null ||
            now.difference(_lastSyncTrigger!) > _syncDebounceTime) {
          _lastSyncTrigger = now;
          return true;
        }
        return false;
      }).asyncExpand(mapper);
    };
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

    // No items to sync
    if (queueCount == 0) {
      emit(SyncIdle(pendingCount: 0, lastSyncTime: _lastSyncTime));
      return;
    }

    // Start syncing
    emit(SyncInProgress(queueCount));

    try {
      // Process the queue with progress updates
      final result = await syncService.processQueue(
        onProgress: (processed, total) {
          if (!emit.isDone) {
            emit(SyncInProgress(
              total,
              progress: processed / total,
              itemsProcessed: processed,
            ));
          }
        },
      );

      _lastSyncTime = DateTime.now();

      if (result.success) {
        // Success - provide haptic feedback
        _triggerSuccessHaptic();

        emit(SyncSuccess(
          message: result.message,
          itemsSynced: result.itemsProcessed,
          timestamp: _lastSyncTime!,
        ));

        // Show success for 2 seconds
        await Future.delayed(const Duration(milliseconds: 2000));

        // Check if there are remaining items
        if (!emit.isDone) {
          final newCount = await syncService.getQueueCount();
          emit(SyncIdle(pendingCount: newCount, lastSyncTime: _lastSyncTime));
        }
      } else {
        // Partial or complete failure
        _triggerErrorHaptic();

        emit(SyncError(
          message: result.message,
          itemsFailed: result.itemsFailed,
          canRetry: result.canRetry,
        ));

        // Show error for 3 seconds
        await Future.delayed(const Duration(milliseconds: 3000));

        if (!emit.isDone) {
          final newCount = await syncService.getQueueCount();
          emit(SyncIdle(pendingCount: newCount, lastSyncTime: _lastSyncTime));
        }
      }
    } catch (e) {
      _triggerErrorHaptic();

      emit(SyncError(
        message: 'Sync failed: ${e.toString()}',
        itemsFailed: queueCount,
        canRetry: true,
      ));

      await Future.delayed(const Duration(milliseconds: 3000));

      if (!emit.isDone) {
        final newCount = await syncService.getQueueCount();
        emit(SyncIdle(pendingCount: newCount, lastSyncTime: _lastSyncTime));
      }
    }
  }

  /// Provide subtle haptic feedback on success
  Future<void> _triggerSuccessHaptic() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 50, amplitude: 64);
      }
    } catch (_) {
      // Silently ignore if vibration fails
    }
  }

  /// Provide error haptic feedback
  Future<void> _triggerErrorHaptic() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 200, amplitude: 128);
      }
    } catch (_) {
      // Silently ignore if vibration fails
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
