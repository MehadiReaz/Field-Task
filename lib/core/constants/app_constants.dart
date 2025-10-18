class AppConstants {
  // App Info
  static const String appName = 'TaskTrackr';
  static const String appVersion = '1.0.0';

  // Location
  static const double proximityThresholdMeters = 100.0;
  static const double defaultLatitude = 0.0;
  static const double defaultLongitude = 0.0;

  // Pagination
  static const int tasksPerPage = 20;
  static const int maxRetryAttempts = 3;

  // Timeouts
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;

  // Cache
  static const int cacheExpiryHours = 24;
  static const String cacheKey = 'task_cache';

  // Image
  static const int maxImageSizeMB = 5;
  static const int imageQuality = 80;

  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy - hh:mm a';

  // Shared Preferences Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLastSyncTime = 'last_sync_time';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorAuth = 'Authentication failed. Please login again.';
  static const String errorLocationPermission = 'Location permission denied';
  static const String errorLocationService = 'Location services disabled';
  static const String errorOutOfRange =
      'You must be within 100m to perform this action';

  // Success Messages
  static const String successTaskCreated = 'Task created successfully';
  static const String successTaskUpdated = 'Task updated successfully';
  static const String successTaskDeleted = 'Task deleted successfully';
  static const String successCheckedIn = 'Checked in successfully';
  static const String successTaskCompleted = 'Task completed successfully';
  static const String successSynced = 'Data synced successfully';
}
