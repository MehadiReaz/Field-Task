import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<ConnectivityStatus>? _statusController;

  Stream<ConnectivityStatus> get statusStream {
    _statusController ??= StreamController<ConnectivityStatus>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _statusController!.stream;
  }

  StreamSubscription<ConnectivityResult>? _subscription;

  void _startListening() {
    // Get initial status
    _checkConnectivity();

    // Listen to changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateStatus(result);
    });
  }

  void _stopListening() {
    _subscription?.cancel();
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateStatus(result);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _statusController?.add(ConnectivityStatus.offline);
    }
  }

  void _updateStatus(ConnectivityResult result) {
    final isConnected = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;

    _statusController?.add(
      isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline,
    );
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _statusController?.close();
  }
}

enum ConnectivityStatus {
  online,
  offline,
}
