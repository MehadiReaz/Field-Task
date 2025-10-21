import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'injection_container.dart';
import 'core/utils/logger.dart';
import 'core/services/local_notification_service.dart';
import 'core/services/expired_tasks_checker_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Firestore settings BEFORE any Firestore operations
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Setup dependency injection
  await configureDependencies();

  // Initialize notification service
  final notificationService = getIt<LocalNotificationService>();
  await notificationService.initialize();
  AppLogger.info('Local notification service initialized');

  // Check for expired tasks on app launch
  final expiredTasksChecker = getIt<ExpiredTasksCheckerService>();
  // Run in background to not block app startup
  Future.delayed(const Duration(seconds: 2), () {
    expiredTasksChecker.checkAndNotifyExpiredTasks();
  });

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Log app startup
  AppLogger.info('TaskTrackr app starting...');

  // Run app with error handling
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TaskTrackrApp();
  }
}
