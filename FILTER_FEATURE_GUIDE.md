# Task Filtering Feature Guide

## Overview
This guide explains how to use the task filtering feature that supports filtering by status (Completed, Checked In, Pending) and by expiration (Expired/Overdue tasks based on due time). The filtering works with both remote (Firestore) and local (SQLite) data sources.

## Features

### Filter Options
1. **All Tasks** - Shows all tasks assigned to the current user
2. **Pending** - Shows tasks with status = 'pending'
3. **Checked In** - Shows tasks with status = 'checked_in'
4. **Completed** - Shows tasks with status = 'completed'
5. **Expired (Overdue)** - Shows tasks that are past their due date and not yet completed

## Architecture

### Data Flow

```
UI (task_list_page.dart)
    ↓ (Dispatches Events)
TaskBloc (task_bloc.dart)
    ↓ (Calls Use Cases)
Use Cases (get_tasks_by_status.dart, get_expired_tasks.dart)
    ↓ (Calls Repository)
Repository (task_repository_impl.dart)
    ↓ (Delegates to Data Sources)
├── Remote Data Source (Firestore) - Primary
└── Local Data Source (SQLite) - Fallback/Offline
```

## Usage Examples

### 1. Using the UI Filter Menu

Users can filter tasks using the filter button in the app bar:

```dart
// In task_list_page.dart
PopupMenuButton<String>(
  icon: const Icon(Icons.filter_list),
  onSelected: (value) {
    _applyFilter(value);
  },
  itemBuilder: (context) => [
    // Filter options with icons
  ],
)
```

### 2. Programmatically Load Filtered Tasks

#### Load Tasks by Status (Remote)
```dart
// Load pending tasks from Firestore
context.read<TaskBloc>().add(
  const LoadTasksByStatusEvent('pending')
);

// Load completed tasks from Firestore
context.read<TaskBloc>().add(
  const LoadTasksByStatusEvent('completed')
);

// Load checked-in tasks from Firestore
context.read<TaskBloc>().add(
  const LoadTasksByStatusEvent('checked_in')
);
```

#### Load Expired Tasks (Remote)
```dart
// Load expired/overdue tasks from Firestore
context.read<TaskBloc>().add(
  const LoadExpiredTasksEvent(useLocal: false)
);
```

#### Load Tasks from Local Database
```dart
// Load pending tasks from local SQLite database
// Requires userId parameter
context.read<TaskBloc>().add(
  const LoadExpiredTasksEvent(
    useLocal: true,
    userId: 'current-user-id',
  )
);
```

### 3. Using Use Cases Directly

If you need to access filtered tasks outside the BLoC pattern:

```dart
// Inject the use case
final getTasksByStatus = getIt<GetTasksByStatus>();

// Get tasks by status from remote
final result = await getTasksByStatus(
  GetTasksByStatusParams(
    status: 'pending',
    useLocal: false,
  ),
);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (tasks) => print('Found ${tasks.length} pending tasks'),
);
```

```dart
// Get expired tasks from local database
final getExpiredTasks = getIt<GetExpiredTasks>();

final result = await getExpiredTasks(
  GetExpiredTasksParams(
    useLocal: true,
    userId: 'current-user-id',
  ),
);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (tasks) => print('Found ${tasks.length} expired tasks'),
);
```

### 4. Repository Level Access

For advanced use cases, you can use the repository directly:

```dart
final repository = getIt<TaskRepository>();

// Get tasks by status (remote)
final remoteResult = await repository.getTasksByStatus('completed');

// Get tasks by status (local)
final localResult = await repository.getTasksByStatusLocal(
  'user-id',
  'pending',
);

// Get expired tasks (remote)
final expiredRemote = await repository.getExpiredTasks();

// Get expired tasks (local)
final expiredLocal = await repository.getExpiredTasksLocal('user-id');
```

## Implementation Details

### Remote Data Source (Firestore)

#### Get Tasks by Status
```dart
Future<List<TaskModel>> getTasksByStatus(String status) async {
  final userId = _currentUserId;
  
  final snapshot = await firestore
      .collection('tasks')
      .where('assignedTo', isEqualTo: userId)
      .where('status', isEqualTo: status)
      .orderBy('dueDate', descending: false)
      .get();

  return snapshot.docs
      .map((doc) => TaskModel.fromFirestore(doc.data()))
      .toList();
}
```

#### Get Expired Tasks
```dart
Future<List<TaskModel>> getExpiredTasks() async {
  final userId = _currentUserId;
  final now = DateTime.now();

  // Get all non-completed tasks
  final snapshot = await firestore
      .collection('tasks')
      .where('assignedTo', isEqualTo: userId)
      .where('status', whereIn: ['pending', 'checked_in'])
      .orderBy('dueDate', descending: false)
      .get();

  // Filter expired tasks on the client side
  return snapshot.docs
      .map((doc) => TaskModel.fromFirestore(doc.data()))
      .where((task) => task.dueDateTime.isBefore(now))
      .toList();
}
```

### Local Data Source (SQLite/Drift)

#### Get Tasks by Status
```dart
Future<List<TaskModel>> getTasksByStatus(
  String userId, 
  String status,
) async {
  final tasks = await database.taskDao.getTasksPaginated(
    userId: userId,
    limit: 10000,
    offset: 0,
    status: status,
  );

  // Convert and sort
  final result = tasks
      .map((e) => TaskModel.fromFirestore(_taskEntityToMap(e)))
      .toList();
      
  result.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
  return result;
}
```

#### Get Expired Tasks
```dart
Future<List<TaskModel>> getExpiredTasks(String userId) async {
  final now = DateTime.now();
  
  final allTasks = await database.taskDao.getTasksPaginated(
    userId: userId,
    limit: 10000,
    offset: 0,
  );

  // Filter for expired tasks
  final expiredTasks = allTasks
      .where((taskEntity) {
        final isPending = taskEntity.status == 'pending' || 
                        taskEntity.status == 'checked_in';
        final isPastDue = taskEntity.dueDateTime.isBefore(now);
        return isPending && isPastDue;
      })
      .toList();

  return expiredTasks
      .map((e) => TaskModel.fromFirestore(_taskEntityToMap(e)))
      .toList();
}
```

## Status Values

The following status values are supported:

- `'pending'` - Task assigned but not started
- `'checked_in'` - Agent has checked in at the task location
- `'checked_out'` - Agent has checked out (no longer shown in active list)
- `'completed'` - Task is completed
- `'cancelled'` - Task is cancelled

## Expired Task Logic

A task is considered expired if:
1. Its `dueDateTime` is before the current time (`DateTime.now()`)
2. AND its status is either `'pending'` or `'checked_in'`
3. Completed or cancelled tasks are never considered expired

## Error Handling

All filtering operations return `Either<Failure, List<Task>>`:

```dart
result.fold(
  (failure) {
    // Handle error
    if (failure is ServerFailure) {
      print('Remote error: ${failure.message}');
    } else if (failure is CacheFailure) {
      print('Local database error: ${failure.message}');
    }
  },
  (tasks) {
    // Handle success
    print('Loaded ${tasks.length} tasks');
  },
);
```

## Offline Support

The feature supports offline operation through the local data source:

1. **Online Mode**: Data is fetched from Firestore and cached locally
2. **Offline Mode**: Use `useLocal: true` parameter to fetch from SQLite cache
3. **Auto-caching**: Remote data is automatically cached for offline access

## Performance Considerations

1. **Remote Filtering**: Done at database level (Firestore queries)
2. **Local Filtering**: Uses indexed queries where possible
3. **Expired Tasks**: Client-side filtering after fetching non-completed tasks
4. **Pagination**: Supported for "All Tasks" view, not for filtered views
5. **Caching**: Remote data is silently cached in background

## Testing

### Unit Test Example
```dart
test('should get pending tasks from remote', () async {
  // Arrange
  when(mockRemoteDataSource.getTasksByStatus('pending'))
      .thenAnswer((_) async => [mockTask]);

  // Act
  final result = await repository.getTasksByStatus('pending');

  // Assert
  expect(result.isRight(), true);
  result.fold(
    (l) => fail('Should succeed'),
    (tasks) => expect(tasks.length, 1),
  );
});
```

### Integration Test Example
```dart
testWidgets('should filter tasks by status', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Tap filter button
  await tester.tap(find.byIcon(Icons.filter_list));
  await tester.pumpAndSettle();
  
  // Select "Pending"
  await tester.tap(find.text('Pending'));
  await tester.pumpAndSettle();
  
  // Verify filtered results
  expect(find.byType(TaskCard), findsWidgets);
});
```

## Future Enhancements

Potential improvements:
1. Combined filters (e.g., "Pending AND Expired")
2. Date range filtering
3. Priority-based filtering
4. Custom filter presets
5. Filter persistence across sessions
6. Real-time filter updates with streams

## Troubleshooting

### No tasks showing after filtering
- Check user is authenticated
- Verify user has tasks with the selected status
- Check network connectivity for remote filters
- Verify local database has cached data for local filters

### Expired tasks not showing correctly
- Verify task `dueDateTime` is set correctly
- Check system time is accurate
- Ensure task status is 'pending' or 'checked_in'

### Local filtering not working
- Ensure tasks have been cached (use remote filter first)
- Provide valid `userId` parameter
- Check local database initialization
