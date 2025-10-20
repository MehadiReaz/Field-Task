# Offline Task List Fix

## Issue
Tasks created offline were being saved to the local database successfully, but they weren't appearing in the task list. The task list would show empty or fail to load when offline because it only queried the remote database.

## Root Cause
The `getTasksPage()` and `getTasks()` methods in `TaskRepositoryImpl` were only fetching from the remote data source without checking network connectivity. This meant:
- When offline, these methods would fail or return empty results
- Tasks saved locally during offline mode were invisible to the user
- The app didn't feel truly offline-first

## Solution
Made both `getTasksPage()` and `getTasks()` network-aware, similar to the pattern already implemented for `getTaskById()`, `createTask()`, `updateTask()`, and `deleteTask()`.

### Changes Made

#### 1. Added FirebaseAuth Dependency to TaskRepositoryImpl
**File:** `lib/features/tasks/data/repositories/task_repository_impl.dart`

```dart
// Added import
import 'package:firebase_auth/firebase_auth.dart';

// Added firebaseAuth to constructor
final FirebaseAuth firebaseAuth;

TaskRepositoryImpl({
  required this.remoteDataSource,
  required this.localDataSource,
  required this.networkInfo,
  required this.database,
  required this.firebaseAuth, // NEW
});

// Added helper to get current user ID
String get _currentUserId {
  final user = firebaseAuth.currentUser;
  if (user == null) throw Exception('User not authenticated');
  return user.uid;
}
```

#### 2. Updated getTasksPage() to Check Network Status
**Before:**
```dart
Future<Either<Failure, TaskPage>> getTasksPage({...}) async {
  try {
    final pageModel = await remoteDataSource.getTasksPage(...);
    return Right(TaskPage(...));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

**After:**
```dart
Future<Either<Failure, TaskPage>> getTasksPage({...}) async {
  final isConnected = await networkInfo.isConnected;

  if (isConnected) {
    // Online: Fetch from remote and cache locally
    final pageModel = await remoteDataSource.getTasksPage(...);
    
    // Cache tasks in background
    for (final task in pageModel.tasks) {
      _cacheTaskSilently(task);
    }
    
    return Right(TaskPage(...));
  } else {
    // Offline: Fetch from local database
    final userId = _currentUserId;
    List<TaskModel> localTasks;

    if (showExpiredOnly) {
      localTasks = await localDataSource.getExpiredTasks(userId);
    } else if (status != null) {
      localTasks = await localDataSource.getTasksByStatus(userId, status);
    } else {
      // Get all pending/checked-in tasks
      final pendingTasks = await localDataSource.getTasksByStatus(userId, 'pending');
      final checkedInTasks = await localDataSource.getTasksByStatus(userId, 'checked_in');
      localTasks = [...pendingTasks, ...checkedInTasks];
      localTasks.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
    }

    return Right(TaskPage(
      tasks: localTasks,
      hasMore: false,  // No pagination in offline mode
      lastDocument: null,
    ));
  }
}
```

#### 3. Updated getTasks() to Check Network Status
**Before:**
```dart
Future<Either<Failure, List<Task>>> getTasks() async {
  try {
    final tasks = await remoteDataSource.getTasks();
    // Cache tasks...
    return Right(tasks);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

**After:**
```dart
Future<Either<Failure, List<Task>>> getTasks() async {
  final isConnected = await networkInfo.isConnected;

  if (isConnected) {
    // Online: Fetch from remote and cache
    final tasks = await remoteDataSource.getTasks();
    for (final task in tasks) {
      _cacheTaskSilently(task);
    }
    return Right(tasks);
  } else {
    // Offline: Fetch from local database
    final userId = _currentUserId;
    final pendingTasks = await localDataSource.getTasksByStatus(userId, 'pending');
    final checkedInTasks = await localDataSource.getTasksByStatus(userId, 'checked_in');
    final allTasks = [...pendingTasks, ...checkedInTasks];
    allTasks.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
    return Right(allTasks);
  }
}
```

#### 4. Regenerated Dependency Injection
```bash
dart run build_runner build --delete-conflicting-outputs
```

This automatically injected `FirebaseAuth` into `TaskRepositoryImpl` constructor.

## Behavior

### When Online
1. Task list queries Firestore (remote database)
2. Results are cached locally in SQLite
3. User sees synced tasks from server
4. Pagination works as expected

### When Offline
1. Task list queries SQLite (local database)
2. Shows tasks filtered by current user ID
3. Includes:
   - Tasks created while offline (not yet synced)
   - Tasks previously cached from remote
   - Tasks with pending/checked_in status (or filtered by status param)
4. No pagination (returns all matching tasks)
5. Sorted by due date

## Testing Scenarios

### Scenario 1: Create Task Offline, View in List
1. Turn off network/WiFi
2. Create a new task
3. ✅ Task appears immediately in task list
4. Turn on network
5. ✅ Task syncs to server
6. ✅ Task still visible in list

### Scenario 2: View Cached Tasks Offline
1. Use app while online (loads tasks)
2. Turn off network
3. ✅ Previously loaded tasks still visible
4. ✅ Can check in, complete, update tasks
5. ✅ All changes visible immediately

### Scenario 3: Filter Tasks Offline
1. Create tasks with different statuses offline
2. Use filter dropdown (All/Pending/Checked In/Completed)
3. ✅ Filters work correctly with local data
4. ✅ Expired tasks filter works

### Scenario 4: Empty State Offline
1. Fresh install or cleared data
2. Turn off network
3. Task list shows "No tasks found"
4. ✅ No crashes or error messages

## Impact
- ✅ Complete offline-first experience
- ✅ Tasks created offline are immediately visible
- ✅ Users can work entirely offline
- ✅ Consistent behavior between online/offline modes
- ✅ All CRUD operations now fully functional offline

## Related Files
- `lib/features/tasks/data/repositories/task_repository_impl.dart` - Main changes
- `lib/features/tasks/data/datasources/task_local_datasource.dart` - Used for offline queries
- `lib/features/tasks/data/datasources/task_remote_datasource.dart` - Used for online queries
- `lib/injection_container.config.dart` - Auto-generated DI updates

## Related Fixes
This completes the offline-first implementation started in:
- OFFLINE_TASK_CRUD_FIX.md - Made create/update/delete work offline
- OFFLINE_CHECKIN_COMPLETE.md - Made check-in/complete work offline
- TIMELINE_SYNC_FIX.md - Fixed sync service and timeline updates
