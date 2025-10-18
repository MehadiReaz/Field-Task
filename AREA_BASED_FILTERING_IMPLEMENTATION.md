# Task Trackr - Area-Based Filtering Implementation Summary

## ✅ Completed Changes

### 1. Fixed User Data Not Saved After Login
- **File**: `lib/features/auth/data/repositories/auth_repository_impl.dart`
- **Changes**: 
  - Added `saveAuthToken()` call after successful Google and email sign-in
  - User data is now properly cached in secure storage along with auth token

### 2. Improved Logout Functionality
- **File**: `lib/features/auth/presentation/pages/profile_page.dart`
- **Changes**:
  - Added logout confirmation dialog
  - Added `BlocListener` to navigate to login page after logout
  - User is properly redirected after sign-out

### 3. Added selectedAreaId to User Entity & Model
- **Files Modified**:
  - `lib/features/auth/domain/entities/user.dart` - Added `selectedAreaId` field
  - `lib/features/auth/data/models/user_model.dart` - Added field to model serialization
  - `lib/features/auth/domain/repositories/auth_repository.dart` - Added `updateUserArea` method
  - `lib/features/auth/data/repositories/auth_repository_impl.dart` - Implemented method
  - `lib/features/auth/data/datasources/auth_remote_datasource.dart` - Added remote update method
  
- **New File Created**:
  - `lib/features/auth/domain/usecases/update_user_area.dart` - Usecase for updating user's selected area

### 4. Created Area Selection Dialog
- **New File**: `lib/features/auth/presentation/widgets/area_selection_dialog.dart`
- **Features**:
  - Shows list of available areas
  - User can select an area
  - Updates the user's selectedAreaId in Firestore
  - Can be shown as required (blocking) or optional
  - Handles loading, error, and empty states

### 5. Area Selection on Login
- **File**: `lib/features/auth/presentation/pages/splash_page.dart`
- **Changes**:
  - After successful authentication, checks if user has selectedAreaId
  - If not selected, shows area selection dialog (required - cannot be dismissed)
  - User must select an area before proceeding to the app

### 6. Change Area Option in Profile
- **File**: `lib/features/auth/presentation/pages/profile_page.dart`
- **Changes**:
  - Added "Work Area" section showing current selected area
  - Added "Change" button to allow users to change their area
  - Opens area selection dialog in optional mode

### 7. Added areaId to Task Entity & Model
- **Files Modified**:
  - `lib/features/tasks/domain/entities/task.dart` - Added `areaId` field
  - `lib/features/tasks/data/models/task_model.dart` - Added field to Firestore serialization

### 8. Task Creation Sets Area Automatically
- **File**: `lib/features/tasks/presentation/pages/task_form_page.dart`
- **Changes**:
  - When creating a new task, automatically sets `areaId` to the user's `selectedAreaId`
  - Tasks are now associated with the user's currently selected area

## ⚠️ Remaining Tasks

### 9. Filter Tasks by Area in Queries
**Files to Modify**:
- `lib/features/tasks/data/datasources/task_remote_datasource.dart`
  - Update `getTasks()` to add `.where('areaId', isEqualTo: userAreaId)` filter
  - Update `watchTasks()` stream to filter by areaId
- `lib/features/tasks/data/datasources/task_local_datasource.dart`
  - Update local database queries to filter by areaId
  - May need to update Drift database schema to add areaId column

**Current Issue**: Tasks are fetched for all users regardless of area. Need to filter by `areaId`.

### 10. Update Firestore Security Rules
**File**: `firestore.rules`

**Required Changes**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ... existing rules ...
    
    match /tasks/{taskId} {
      allow read, write: if request.auth != null 
        && (request.auth.uid == resource.data.assignedTo 
        || request.auth.uid == resource.data.createdBy)
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.selectedAreaId == resource.data.areaId;
    }
    
    match /areas/{areaId} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth != null 
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'manager'];
    }
  }
}
```

## 📝 Testing Checklist

- [ ] Login with Google - verify auth token is saved
- [ ] Login with email - verify auth token is saved
- [ ] Logout - verify redirect to login page
- [ ] First login - verify area selection dialog appears (required)
- [ ] Select area on first login - verify user can proceed to app
- [ ] Profile page - verify "Change Area" button works
- [ ] Create task - verify areaId is set automatically
- [ ] Task list - verify only tasks from selected area are shown (after implementing filter)
- [ ] Change area in profile - verify task list updates
- [ ] Firestore security - verify users can only access tasks from their area

## 🔧 Additional Improvements Needed

### Database Migration for Drift
The local Drift database needs to be updated to include the areaId column:
1. Add `areaId` column to Tasks table in `lib/database/tables/tasks_table.dart`
2. Run database migration
3. Update local queries to filter by areaId

### UI Enhancements
1. Show area name in profile (not just ID) - fetch from areas collection
2. Show area badge on tasks in task list
3. Add area filter dropdown in task list header
4. Show warning if user changes area with pending tasks

### Error Handling
1. Handle case where user's selectedAreaId refers to non-existent/deleted area
2. Handle case where area has no tasks
3. Better offline support for area data

## 📦 Dependencies
All required dependencies are already in pubspec.yaml:
- firebase_auth
- cloud_firestore
- flutter_secure_storage
- flutter_bloc
- go_router
- uuid

## 🚀 Deployment Notes

1. **Firebase Console**: Update Firestore Rules before deploying
2. **Existing Users**: Run a migration script to assign default areas to existing users
3. **Testing**: Test with multiple users in different areas
4. **Rollback Plan**: Keep old task queries available as fallback

## 📊 Data Structure

### User Document (Firestore: `users/{userId}`)
```json
{
  "id": "user123",
  "email": "user@example.com",
  "displayName": "John Doe",
  "role": "agent",
  "selectedAreaId": "area456",  // NEW FIELD
  "createdAt": "2025-10-18T10:00:00Z",
  "updatedAt": "2025-10-18T10:00:00Z"
}
```

### Task Document (Firestore: `tasks/{taskId}`)
```json
{
  "id": "task789",
  "title": "Fix Issue",
  "description": "Details...",
  "areaId": "area456",  // NEW FIELD
  "assignedTo": "user123",
  "status": "pending",
  "locationLat": 23.8103,
  "locationLng": 90.4125,
  ...
}
```

### Area Document (Firestore: `areas/{areaId}`)
```json
{
  "id": "area456",
  "name": "Banani Zone",
  "centerLatitude": 23.7937,
  "centerLongitude": 90.4066,
  "radiusInMeters": 500,
  "description": "Commercial area",
  "isActive": true
}
```

## 🎯 Next Steps Priority

1. **HIGH**: Implement task filtering by areaId in remote and local datasources
2. **HIGH**: Update Firestore security rules  
3. **MEDIUM**: Add database migration for areaId column in Drift
4. **MEDIUM**: Show area name instead of ID in UI
5. **LOW**: Add area-based analytics/reports
