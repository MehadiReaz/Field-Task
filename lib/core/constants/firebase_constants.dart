class FirebaseConstants {
  // Collections
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';
  static const String checkInsCollection = 'checkIns';

  // Storage
  static const String taskPhotosFolder = 'task_photos';
  static const String checkInPhotosFolder = 'checkin_photos';
  static const String completionPhotosFolder = 'completion_photos';
  static const String profilePhotosFolder = 'profile_photos';

  // User Fields
  static const String fieldUserId = 'id';
  static const String fieldEmail = 'email';
  static const String fieldDisplayName = 'displayName';
  static const String fieldPhotoUrl = 'photoUrl';
  static const String fieldRole = 'role';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';
  static const String fieldIsActive = 'isActive';

  // Task Fields
  static const String fieldTaskId = 'id';
  static const String fieldTitle = 'title';
  static const String fieldDescription = 'description';
  static const String fieldDueDate = 'dueDate';
  static const String fieldStatus = 'status';
  static const String fieldPriority = 'priority';
  static const String fieldLocationLat = 'locationLat';
  static const String fieldLocationLng = 'locationLng';
  static const String fieldLocationAddress = 'locationAddress';
  static const String fieldAssignedTo = 'assignedTo';
  static const String fieldAssignedToName = 'assignedToName';
  static const String fieldCreatedBy = 'createdBy';
  static const String fieldCreatedByName = 'createdByName';
  static const String fieldCheckedInAt = 'checkedInAt';
  static const String fieldCompletedAt = 'completedAt';
  static const String fieldPhotoUrls = 'photoUrls';
  static const String fieldCheckInPhotoUrl = 'checkInPhotoUrl';
  static const String fieldCompletionPhotoUrl = 'completionPhotoUrl';
  static const String fieldCompletionNotes = 'completionNotes';
  static const String fieldMetadata = 'metadata';

  // Query Limits
  static const int defaultQueryLimit = 50;
  static const int maxQueryLimit = 100;

  // Firestore Settings
  static const bool persistenceEnabled = true;
  static const int cacheSizeBytes = -1; // Unlimited
}
