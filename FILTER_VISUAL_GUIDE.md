# Task Filter Feature - Visual Guide

## Filter Menu UI

```
┌─────────────────────────────────────┐
│  My Tasks               [Filter] ⚙  │  ← App Bar
├─────────────────────────────────────┤
│                                     │
│  When user taps filter button:     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ☰ All Tasks                │   │
│  ├─────────────────────────────┤   │
│  │ ⏱ Pending                  │   │
│  ├─────────────────────────────┤   │
│  │ ✓ Checked In               │   │
│  ├─────────────────────────────┤   │
│  │ ✓✓ Completed               │   │
│  ├─────────────────────────────┤   │
│  │ ───────────────────────────│   │
│  ├─────────────────────────────┤   │
│  │ ⚠ Expired (Overdue)        │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

## Active Filter Display

```
┌─────────────────────────────────────┐
│  My Tasks               [Filter] ⚙  │
├─────────────────────────────────────┤
│  [Search tasks...]                  │
├─────────────────────────────────────┤
│  Showing 5 tasks  [Pending ✕]      │  ← Active filter chip
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Task 1 - Meeting             │   │
│  │ Due: Today 2:00 PM          │   │
│  │ Status: Pending             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Task 2 - Review Document    │   │
│  │ Due: Tomorrow 10:00 AM      │   │
│  │ Status: Pending             │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

## Data Flow Diagram

```
┌─────────────┐
│    User     │
│  Taps Filter│
└──────┬──────┘
       │ 
       │ Selects "Pending"
       │
       ▼
┌──────────────────────┐
│  _applyFilter()      │
│  - Updates state     │
│  - Dispatches event  │
└──────┬───────────────┘
       │
       │ LoadTasksByStatusEvent('pending')
       │
       ▼
┌──────────────────────┐
│   TaskBloc           │
│  _onLoadTasksByStatus│
└──────┬───────────────┘
       │
       │ Calls GetTasksByStatus
       │
       ▼
┌──────────────────────┐
│  GetTasksByStatus    │
│  UseCase             │
└──────┬───────────────┘
       │
       │ Calls repository
       │
       ▼
┌──────────────────────┐
│  TaskRepository      │
│  getTasksByStatus()  │
└──────┬───────────────┘
       │
       ├─────────────────┬──────────────────┐
       │                 │                  │
       ▼                 ▼                  ▼
┌─────────────┐   ┌─────────────┐   ┌──────────────┐
│  Remote DS  │   │  Cache      │   │  Local DS    │
│  Firestore  │   │  Silently   │   │  SQLite      │
│             │   │             │   │  (Fallback)  │
└──────┬──────┘   └─────────────┘   └──────────────┘
       │
       │ Returns List<Task>
       │
       ▼
┌──────────────────────┐
│  TaskBloc emits      │
│  TasksLoaded(tasks)  │
└──────┬───────────────┘
       │
       │ BlocBuilder rebuilds
       │
       ▼
┌──────────────────────┐
│  UI displays         │
│  filtered tasks      │
└──────────────────────┘
```

## Filter Logic Flow

### Status Filter
```
Input: status = "pending"

┌───────────────────────────────────┐
│  Firestore Query                  │
│  .where('assignedTo', '=', userId)│
│  .where('status', '=', 'pending') │
│  .orderBy('dueDate')              │
└──────────┬────────────────────────┘
           │
           ▼
    ┌──────────────┐
    │  Results     │
    │  [Task 1]    │
    │  [Task 2]    │
    │  [Task 3]    │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │  Cache       │
    │  locally     │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │  Return to   │
    │  UI          │
    └──────────────┘
```

### Expired Filter
```
Input: Get expired tasks

┌───────────────────────────────────────┐
│  Firestore Query                      │
│  .where('assignedTo', '=', userId)    │
│  .where('status', 'in',               │
│         ['pending', 'checked_in'])    │
│  .orderBy('dueDate')                  │
└──────────┬────────────────────────────┘
           │
           ▼
    ┌──────────────────────────────┐
    │  Client-Side Filter          │
    │  tasks.where(                │
    │    (task) =>                 │
    │    task.dueDateTime <        │
    │    DateTime.now()            │
    │  )                          │
    └──────┬───────────────────────┘
           │
           ▼
    ┌──────────────┐
    │  Expired     │
    │  Tasks       │
    │  [Task 1]    │
    │  [Task 4]    │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │  Cache &     │
    │  Return      │
    └──────────────┘
```

## State Management

```
Initial State:
┌──────────────────┐
│  TaskInitial     │
└──────────────────┘

User applies filter:
┌──────────────────┐
│  TaskLoading     │  ← Shows loading spinner
└──────────────────┘

Data received:
┌──────────────────┐
│  TasksLoaded     │  ← Shows filtered tasks
│  - tasks: [...]  │
│  - hasMore: bool │
│  - lastDoc: Doc  │
└──────────────────┘

OR if no tasks:
┌──────────────────┐
│  TasksEmpty      │  ← Shows empty state
└──────────────────┘

OR if error:
┌──────────────────┐
│  TaskError       │  ← Shows error message
│  - message: str  │
└──────────────────┘
```

## Offline Support Flow

```
┌──────────────────────────────────────┐
│  User Opens App                      │
└──────────┬───────────────────────────┘
           │
           ▼
    ┌─────────────┐
    │  Check      │
    │  Network    │
    └──────┬──────┘
           │
           ├─────────────┬─────────────┐
           │             │             │
           ▼             ▼             ▼
    ┌──────────┐  ┌──────────┐  ┌──────────┐
    │  Online  │  │  Offline │  │  Slow    │
    └────┬─────┘  └────┬─────┘  └────┬─────┘
         │             │              │
         │             │              │
         ▼             ▼              ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ Fetch from  │ │ Fetch from  │ │ Try Remote  │
│ Firestore   │ │ SQLite      │ │ Timeout →   │
│             │ │ Cache       │ │ Use Cache   │
└──────┬──────┘ └──────┬──────┘ └──────┬──────┘
       │               │               │
       │               │               │
       ▼               ▼               ▼
┌─────────────────────────────────────────┐
│  Auto-cache in background               │
│  for offline access                     │
└─────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────┐
│  Display Tasks                          │
└─────────────────────────────────────────┘
```

## Filter Options Summary

| Filter | Status Values | Due Date Check | Result |
|--------|--------------|----------------|---------|
| All | (any) | No | All assigned tasks |
| Pending | `pending` | No | Not started tasks |
| Checked In | `checked_in` | No | Agent at location |
| Completed | `completed` | No | Finished tasks |
| Expired | `pending` OR `checked_in` | Yes (< now) | Overdue tasks |

## Error States

```
Network Error:
┌─────────────────────────────────────┐
│  ⚠ Connection Error                 │
│                                     │
│  Unable to fetch tasks from server. │
│                                     │
│  [Try Again]  [Use Cached Data]     │
└─────────────────────────────────────┘

No Results:
┌─────────────────────────────────────┐
│  🔍 No Tasks Found                  │
│                                     │
│  No tasks match the selected filter.│
│                                     │
│  [Clear Filter]                     │
└─────────────────────────────────────┘

Empty State (All Filters):
┌─────────────────────────────────────┐
│  📋 No Tasks                        │
│                                     │
│  Tasks assigned to you will appear  │
│  here.                              │
└─────────────────────────────────────┘
```

## Code Example - Complete Flow

```dart
// 1. User taps filter button
onPressed: () => _showFilterMenu(),

// 2. User selects "Pending"
onSelected: (value) => _applyFilter(value),

// 3. Apply filter updates state and dispatches event
void _applyFilter(String filter) {
  setState(() {
    _currentFilter = filter;
  });
  
  final bloc = context.read<TaskBloc>();
  
  if (filter == 'expired') {
    bloc.add(const LoadExpiredTasksEvent(useLocal: false));
  } else if (filter == 'all') {
    bloc.add(const LoadMyTasksEvent(isRefresh: true));
  } else {
    bloc.add(LoadTasksByStatusEvent(filter));
  }
}

// 4. BLoC handles event
Future<void> _onLoadTasksByStatus(event, emit) async {
  emit(const TaskLoading());
  
  final result = await getTasksByStatus(
    GetTasksByStatusParams(status: event.status)
  );
  
  result.fold(
    (failure) => emit(TaskError(failure.message)),
    (tasks) => emit(tasks.isEmpty 
      ? const TasksEmpty() 
      : TasksLoaded(tasks)),
  );
}

// 5. Use case executes
Future<Either<Failure, List<Task>>> call(params) async {
  return await repository.getTasksByStatus(params.status);
}

// 6. Repository delegates to data source
Future<Either<Failure, List<Task>>> getTasksByStatus(status) async {
  try {
    final tasks = await remoteDataSource.getTasksByStatus(status);
    // Auto-cache
    for (final task in tasks) {
      _cacheTaskSilently(task);
    }
    return Right(tasks);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

// 7. Remote data source queries Firestore
Future<List<TaskModel>> getTasksByStatus(status) async {
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

// 8. UI rebuilds with filtered data
BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TasksLoaded) {
      return ListView.builder(
        itemCount: state.tasks.length,
        itemBuilder: (context, index) {
          return TaskCard(task: state.tasks[index]);
        },
      );
    }
    // ... other states
  },
)
```
