import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationService {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get scaffoldKey => _scaffoldKey;

  /// Show success message
  void showSuccess(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: Colors.green,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Show info message
  void showInfo(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      icon: Icons.info_rounded,
      backgroundColor: Colors.blue,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Show warning message
  void showWarning(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      icon: Icons.warning_rounded,
      backgroundColor: Colors.orange,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// Show error message
  void showError(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      icon: Icons.error_rounded,
      backgroundColor: Colors.red,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// Show offline mode notification
  void showOfflineMode(String action) {
    _showSnackBar(
      message: '$action • Will sync when online',
      icon: Icons.cloud_off_rounded,
      backgroundColor: Colors.deepOrange,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show sync notification
  void showSyncing(int count) {
    _showSnackBar(
      message: 'Syncing $count ${count == 1 ? 'item' : 'items'}...',
      icon: Icons.sync_rounded,
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 2),
    );
  }

  void _showSnackBar({
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: duration,
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
