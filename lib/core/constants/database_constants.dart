class DatabaseConstants {
  // Database
  static const String databaseName = 'field_task_db.sqlite';
  static const int databaseVersion = 1;

  // Tables
  static const String tasksTable = 'tasks';
  static const String usersTable = 'users';
  static const String syncQueueTable = 'sync_queue';

  // Tasks Table Columns
  static const String columnTaskId = 'id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnDueDateTime = 'due_date_time';
  static const String columnStatus = 'status';
  static const String columnPriority = 'priority';
  static const String columnLatitude = 'latitude';
  static const String columnLongitude = 'longitude';
  static const String columnAddress = 'address';
  static const String columnAssignedToId = 'assigned_to_id';
  static const String columnAssignedToName = 'assigned_to_name';
  static const String columnCreatedById = 'created_by_id';
  static const String columnCreatedByName = 'created_by_name';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnCheckedInAt = 'checked_in_at';
  static const String columnCompletedAt = 'completed_at';
  static const String columnPhotoUrls = 'photo_urls';
  static const String columnCheckInPhotoUrl = 'check_in_photo_url';
  static const String columnCompletionPhotoUrl = 'completion_photo_url';
  static const String columnSyncStatus = 'sync_status';
  static const String columnCompletionNotes = 'completion_notes';
  static const String columnMetadata = 'metadata';

  // Users Table Columns
  static const String columnUserId = 'id';
  static const String columnEmail = 'email';
  static const String columnDisplayName = 'display_name';
  static const String columnPhotoUrl = 'photo_url';
  static const String columnRole = 'role';
  static const String columnUserCreatedAt = 'created_at';
  static const String columnUserUpdatedAt = 'updated_at';
  static const String columnIsActive = 'is_active';
  static const String columnPhoneNumber = 'phone_number';
  static const String columnDepartment = 'department';

  // Sync Queue Table Columns
  static const String columnSyncId = 'id';
  static const String columnSyncTaskId = 'task_id';
  static const String columnOperation = 'operation';
  static const String columnPayload = 'payload';
  static const String columnTimestamp = 'timestamp';
  static const String columnRetryCount = 'retry_count';
  static const String columnLastRetryAt = 'last_retry_at';
  static const String columnErrorMessage = 'error_message';

  // Sync Operations
  static const String operationCreate = 'CREATE';
  static const String operationUpdate = 'UPDATE';
  static const String operationDelete = 'DELETE';

  // Sync Status
  static const String syncStatusPending = 'pending';
  static const String syncStatusSyncing = 'syncing';
  static const String syncStatusSynced = 'synced';
  static const String syncStatusFailed = 'failed';

  // Query Limits
  static const int defaultLimit = 50;
  static const int maxLimit = 200;
}
