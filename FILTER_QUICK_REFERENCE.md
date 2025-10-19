# Task Filter - Quick Reference

## UI Usage

### Apply Filter from UI
```dart
// User taps filter button and selects option
// Handled automatically in task_list_page.dart
```

### Filter Options
- **All Tasks** - No filter applied
- **Pending** - `status = 'pending'`
- **Checked In** - `status = 'checked_in'`  
- **Completed** - `status = 'completed'`
- **Expired** - Past due date and not completed

## BLoC Events

### Load All Tasks
```dart
context.read<TaskBloc>().add(const LoadMyTasksEvent(isRefresh: true));
```

### Load by Status
```dart
// Pending
context.read<TaskBloc>().add(const LoadTasksByStatusEvent('pending'));

// Checked In
context.read<TaskBloc>().add(const LoadTasksByStatusEvent('checked_in'));

// Completed
context.read<TaskBloc>().add(const LoadTasksByStatusEvent('completed'));
```

### Load Expired Tasks
```dart
// Remote (Firestore)
context.read<TaskBloc>().add(const LoadExpiredTasksEvent(useLocal: false));

// Local (SQLite) - Requires userId
context.read<TaskBloc>().add(
  const LoadExpiredTasksEvent(
    useLocal: true,
    userId: 'user-id-here',
  ),
);
```

## Use Cases

### GetTasksByStatus
```dart
final useCase = getIt<GetTasksByStatus>();

// Remote
final result = await useCase(GetTasksByStatusParams(
  status: 'pending',
  useLocal: false,
));

// Local
final result = await useCase(GetTasksByStatusParams(
  status: 'pending',
  useLocal: true,
  userId: 'user-id',
));
```

### GetExpiredTasks
```dart
final useCase = getIt<GetExpiredTasks>();

// Remote
final result = await useCase(GetExpiredTasksParams(useLocal: false));

// Local
final result = await useCase(GetExpiredTasksParams(
  useLocal: true,
  userId: 'user-id',
));
```

## Repository Methods

### Remote Operations
```dart
// Get by status
await repository.getTasksByStatus('pending');

// Get expired
await repository.getExpiredTasks();
```

### Local Operations
```dart
// Get by status
await repository.getTasksByStatusLocal('user-id', 'pending');

// Get expired
await repository.getExpiredTasksLocal('user-id');
```

## Status Values

| Status | Value | Description |
|--------|-------|-------------|
| Pending | `'pending'` | Not started |
| Checked In | `'checked_in'` | Agent at location |
| Checked Out | `'checked_out'` | No longer active |
| Completed | `'completed'` | Task done |
| Cancelled | `'cancelled'` | Task cancelled |

## Expired Logic

```
Task is Expired IF:
  - dueDateTime < DateTime.now()
  AND
  - status IN ['pending', 'checked_in']
```

## Data Sources

### Remote (Firestore)
- `getTasksByStatus(String status)`
- `getExpiredTasks()`

### Local (SQLite)
- `getTasksByStatus(String userId, String status)`
- `getExpiredTasks(String userId)`

## Result Handling

```dart
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (tasks) => print('Success: ${tasks.length} tasks'),
);
```

## Common Patterns

### Show Loading → Load → Display
```dart
// 1. Show loading
emit(const TaskLoading());

// 2. Load data
final result = await useCase(params);

// 3. Display
result.fold(
  (failure) => emit(TaskError(failure.message)),
  (tasks) => tasks.isEmpty
      ? emit(const TasksEmpty())
      : emit(TasksLoaded(tasks)),
);
```

### Remote with Local Fallback
```dart
try {
  // Try remote first
  final result = await repository.getTasksByStatus(status);
  return result;
} catch (e) {
  // Fallback to local
  return await repository.getTasksByStatusLocal(userId, status);
}
```
