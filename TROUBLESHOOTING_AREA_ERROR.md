# Troubleshooting Guide: Area Selection Dialog

## Common Issues and Solutions

### 1. "Server error occurred" appears

**Cause**: Date/Timestamp parsing failure in Firestore data  
**Solution**: 
- The fix now handles both Firestore Timestamps and ISO8601 strings
- Check Firebase Console logs for specific errors
- Verify area documents have valid createdAt and updatedAt timestamps

**How to verify the fix**:
```
1. Open the app and proceed to area selection
2. Check Device Logs / Flutter Console for detailed error messages
3. Look for "Error fetching areas: " messages which will show the exact issue
```

### 2. "No areas available" appears

**Cause**: Either no areas in Firestore or Firebase rules block access  
**Solution**:
- Add an area using the ADD_AREA_GUIDE.md
- Check Firestore rules allow read access to areas collection
- Verify areas have `isActive: true`

### 3. Area appears in Firebase but not in app

**Cause**: Firestore rules or data format issue  
**Solution**:
1. Verify the area document has all required fields:
   - id (String)
   - name (String)
   - centerLatitude (Number)
   - centerLongitude (Number)
   - radiusInMeters (Number)
   - assignedAgentIds (Array)
   - createdById (String)
   - createdByName (String)
   - createdAt (Timestamp)
   - updatedAt (Timestamp)
   - isActive (Boolean, set to true)
   - description (String, optional)

2. Check Firestore rules:
```firestore
// Should allow reading areas
match /areas/{areaId} {
  allow read: if request.auth != null;
}
```

### 4. Date parsing errors in logs

**Cause**: Unexpected date format in Firestore  
**Solution**:
- `TimestampHelper` now handles multiple formats
- If still seeing errors, check the area document timestamps
- Timestamps should be Firestore Timestamp type, not strings

### 5. App crashes after selecting area

**Cause**: User not properly updated with selectedAreaId  
**Solution**:
1. Ensure UpdateUserArea usecase is properly injected
2. Check Firebase rules allow updating user documents
3. Verify user document has selectedAreaId field

## Debugging Steps

### Step 1: Check Firestore Data
```
1. Go to Firebase Console > Firestore Database
2. Look for 'areas' collection
3. Check each area document has the required fields
4. Verify createdAt and updatedAt are Timestamp type (not strings)
5. Check isActive is true
```

### Step 2: Enable Debug Logging
In area_bloc.dart, the error messages now include full details:
```
Error fetching areas: [specific error message]
```

Check your Flutter console for these messages.

### Step 3: Verify Firebase Rules
Check that your Firestore rules allow:
```
match /areas/{document=**} {
  allow read: if request.auth != null;
}
```

### Step 4: Check App Logs
```
1. Run: flutter run -v
2. Look for "Error fetching areas:" messages
3. Copy full error message
4. Search for that error in Firestore or Firebase docs
```

## Fix Applied

The following fix was applied to handle Firestore Timestamps properly:

### Created: TimestampHelper
- Handles Firestore Timestamp objects
- Falls back to DateTime.parse() for strings
- Gracefully handles null values

### Updated: Models
- AreaModel.fromFirestore()
- TaskModel.fromFirestore()
- UserModel.fromJson()

### Improved: Error Messages
- ServerFailure now accepts custom messages
- Better visibility into actual errors

## If Issue Persists

1. **Clear app cache**:
   ```
   flutter clean
   flutter pub get
   ```

2. **Rebuild the app**:
   ```
   flutter run
   ```

3. **Check Firebase emulator** (if using local testing):
   - Ensure emulator is running
   - Check Firestore emulator has area data

4. **Verify Firebase configuration**:
   - Check google-services.json is current
   - Verify Firebase project ID matches

## Need More Help?

1. Check app logs in Flutter console
2. Look for "Error fetching areas: " messages
3. Verify Firestore rules and data format
4. Ensure Firebase authentication is working (you can log in)
5. Run `flutter analyze` to check for other issues
