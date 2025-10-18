# Updated: Display Area Name Instead of Area ID

## Changes Made

Updated the task form and user model to display the **area name** instead of the area ID. Now when users create a task, they see a friendly area name like "Banani Zone" instead of just the area ID.

## How It Works

### 1. **Store Area Name in User Entity**
   - Added `selectedAreaName` field to the User entity
   - Stored alongside `selectedAreaId`
   - Updated whenever user changes their selected area

### 2. **Fetch Area Name on Area Selection**
   - When user selects an area, the `UpdateUserArea` usecase now:
     1. Gets the area ID from the selected area
     2. Fetches the area document from Firestore to get the name
     3. Stores both the ID and name in the user document
     4. Returns the updated user

### 3. **Display in Task Form**
   - Task form now shows `selectedAreaName` instead of `selectedAreaId`
   - Example: "Banani Zone" instead of "area-banani-001"
   - Green checkmark icon indicates it's validated

## Files Modified

### 1. **lib/features/auth/domain/entities/user.dart**
   - Added `selectedAreaName` field
   - Updated `props` list to include it
   - Updated `copyWith()` method

### 2. **lib/features/auth/data/models/user_model.dart**
   - Added `selectedAreaName` parameter to constructor
   - Updated `fromJson()` to deserialize selectedAreaName
   - Updated `toJson()` to serialize selectedAreaName
   - Updated `fromEntity()` to include selectedAreaName

### 3. **lib/features/auth/data/datasources/auth_remote_datasource.dart**
   - Enhanced `updateUserArea()` to:
     1. Fetch area document from Firestore
     2. Extract area name from the document
     3. Store both `selectedAreaId` and `selectedAreaName` in user document
     4. Handle missing area gracefully (falls back to ID)

### 4. **lib/features/tasks/presentation/pages/task_form_page.dart**
   - Changed from: `authState.user.selectedAreaId ?? 'No area selected'`
   - Changed to: `authState.user.selectedAreaName ?? 'No area selected'`

## User Flow

1. User logs in
2. Area selection dialog appears
3. User selects "Banani Zone"
4. App fetches area name and stores in user document:
   ```
   selectedAreaId: "area-banani-001"
   selectedAreaName: "Banani Zone"
   ```
5. User creates a task
6. Task form displays: **"Banani Zone"** instead of "area-banani-001"
7. Green checkmark shows area is validated

## Benefits

✅ **User-friendly display** - Shows area names instead of IDs  
✅ **Consistent experience** - Area name shown everywhere  
✅ **Automatic updates** - Name updated when user changes area  
✅ **Graceful fallback** - Uses ID if name unavailable  
✅ **Better UX** - Users understand which area they're working in  

## Firestore Schema Update

The user document now stores:
```json
{
  "id": "user-id",
  "email": "user@example.com",
  "displayName": "John Doe",
  "selectedAreaId": "area-banani-001",
  "selectedAreaName": "Banani Zone",
  ...other fields
}
```

## Testing

1. Log in to the app
2. Select an area (e.g., "Banani Zone")
3. Go to create a task
4. Verify the "Working Area" field shows "Banani Zone" not the ID
5. Change your area in the profile page
6. Create another task and verify the area name is updated

## Backward Compatibility

- Existing users without `selectedAreaName` will work fine
- When they select an area, the name will be fetched and saved
- Falls back gracefully if area cannot be found

## Related Files

- See `TASK_FORM_UPDATE.md` for task form changes
- See `ADD_AREA_GUIDE.md` for how to add areas
- See `FIX_SERVER_ERROR_DIALOG.md` for timestamp fixes
