# Fixed: "Server error occurred" in Area Selection Dialog

## Problem
When the app tried to load areas from Firestore, it was throwing "Server error occurred" and not displaying the list of areas. This prevented users from completing the area selection flow.

## Root Cause
The issue was in how Firestore Timestamps were being parsed:

1. **Firestore Timestamp Format**: When you add a document in Firebase Console with current date/time, Firestore stores it as a Timestamp object (e.g., "October 18, 2025 at 12:58:32 PM UTC+6")

2. **Code Assumption**: The `AreaModel.fromFirestore()` method was trying to parse these Timestamps as ISO8601 strings using `DateTime.parse()`, which only works for String values

3. **Parse Failure**: When `DateTime.parse()` received a Firestore Timestamp object instead of a string, it threw an exception, which was caught and converted to a generic "Server error occurred" message

## Solution
Created a reusable `TimestampHelper` class that handles multiple date formats:

### New File: `lib/core/utils/timestamp_helper.dart`
```dart
class TimestampHelper {
  static DateTime parseDateTime(dynamic value) {
    // Handles:
    // - Firestore Timestamp objects (calls .toDate())
    // - ISO8601 String values (uses DateTime.parse())
    // - DateTime objects (returns as-is)
    // - null values (returns DateTime.now())
  }
}
```

### Updated Models
Applied `TimestampHelper.parseDateTime()` to:
1. `AreaModel.fromFirestore()` - For area date fields
2. `TaskModel.fromFirestore()` - For task date fields  
3. `UserModel.fromJson()` - For user date fields

### Improved Error Handling
Updated `ServerFailure` class to accept optional error messages:
```dart
class ServerFailure extends SyncFailure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}
```

This allows repositories to provide specific error information:
```dart
return Left(ServerFailure('Failed to fetch areas: $e'));
```

## Files Modified
1. `lib/core/utils/timestamp_helper.dart` - NEW
2. `lib/core/errors/failures.dart` - Enhanced ServerFailure
3. `lib/features/areas/data/models/area_model.dart` - Use TimestampHelper
4. `lib/features/areas/data/repositories/area_repository_impl.dart` - Better error logging
5. `lib/features/tasks/data/models/task_model.dart` - Use TimestampHelper
6. `lib/features/auth/data/models/user_model.dart` - Use TimestampHelper

## Testing
The fix should now:
1. ✅ Load areas from Firestore without errors
2. ✅ Display the list of available areas in the dialog
3. ✅ Allow users to select an area
4. ✅ Proceed to the main app after area selection

## Next Steps
1. Run the app
2. Complete the login flow
3. The area selection dialog should now show your areas
4. Select an area and proceed

If you still see "Server error occurred", check:
1. Firebase Console > Firestore > Check areas collection exists and has documents
2. Check Firebase rules allow read access to areas collection
3. Check app logs in console for specific error messages
