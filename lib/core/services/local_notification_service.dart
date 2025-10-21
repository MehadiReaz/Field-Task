import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import '../utils/logger.dart';

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Android initialization settings
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize with settings
      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == true) {
        _isInitialized = true;
        AppLogger.info('Local notification service initialized successfully');
      } else {
        AppLogger.warning('Local notification initialization returned false');
      }

      // Request permissions for Android 13+
      await _requestPermissions();
    } catch (e) {
      AppLogger.error('Failed to initialize local notification service: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      // For Android 13+ (API 33+)
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      // For iOS
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      AppLogger.error('Failed to request notification permissions: $e');
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.info('Notification tapped: ${response.payload}');
    // You can add navigation logic here if needed
  }

  /// Show notification for expired tasks
  Future<void> showExpiredTasksNotification({
    required int expiredCount,
    String? taskTitle,
  }) async {
    if (!_isInitialized) {
      AppLogger.warning('Local notification service not initialized');
      return;
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'expired_tasks_channel',
        'Expired Tasks',
        channelDescription: 'Notifications for expired/overdue tasks',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'Expired Tasks',
        icon: '@mipmap/ic_launcher',
        color: Color(0xFFFF6B6B), // Red color for urgency
        enableVibration: true,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Create notification title and body
      String title;
      String body;

      if (expiredCount == 1 && taskTitle != null) {
        title = '⚠️ Task Overdue';
        body = '"$taskTitle" is past its due date';
      } else {
        title = '⚠️ $expiredCount Tasks Overdue';
        body = 'You have $expiredCount tasks that are past their due dates';
      }

      await _notifications.show(
        0, // Notification ID
        title,
        body,
        notificationDetails,
        payload: 'expired_tasks',
      );

      AppLogger.info('Expired tasks notification shown: $expiredCount tasks');
    } catch (e) {
      AppLogger.error('Failed to show expired tasks notification: $e');
    }
  }

  /// Show daily reminder for pending tasks
  Future<void> showPendingTasksReminder(int pendingCount) async {
    if (!_isInitialized || pendingCount == 0) return;

    try {
      const androidDetails = AndroidNotificationDetails(
        'pending_tasks_channel',
        'Pending Tasks',
        channelDescription: 'Reminders for pending tasks',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        1, // Different ID for pending tasks
        '📋 Pending Tasks',
        'You have $pendingCount pending tasks to complete',
        notificationDetails,
        payload: 'pending_tasks',
      );

      AppLogger.info('Pending tasks reminder shown: $pendingCount tasks');
    } catch (e) {
      AppLogger.error('Failed to show pending tasks reminder: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      AppLogger.info('All notifications cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel notifications: $e');
    }
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
      AppLogger.info('Notification $id cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel notification: $e');
    }
  }
}
