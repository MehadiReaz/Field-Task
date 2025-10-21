# 📊 Dashboard & Expiry System - Complete Implementation

**Date:** October 21, 2025  
**Status:** ✅ IMPLEMENTED

---

## 🎯 Overview

This implementation adds two critical features:

1. **Dashboard Collection** - Real-time task count tracking in Firebase
2. **Automatic Expiry Detection** - Tasks are checked and marked as expired on each load

---

## 🏗️ Architecture

### **1. Dashboard Service** (`lib/core/services/dashboard_service.dart`)

Manages a `dashboard` collection in Firestore that tracks task counts by status.

#### **Dashboard Document Structure:**
```json
{
  "userId": "user123",
  "total": 15,
  "pending": 5,
  "checkedIn": 3,
  "completed": 4,
  "expired": 2,
  "cancelled": 1,
  "lastUpdated": "2025-10-21T10:30:00Z"
}
```

#### **Key Methods:**

- `initializeDashboard()` - Initialize with zero counts
- `recalculateAllCounts()` - Recalculate from all tasks (fallback)
- `incrementCount(status)` - Add 1 to a status count
- `decrementCount(status)` - Subtract 1 from a status count
- `updateStatusCounts(oldStatus, newStatus)` - Handle status changes
- `watchDashboard()` - Stream of real-time counts
- `getDashboard()` - Get counts once

---

### **2. Task Expiry Service** (`lib/core/services/task_expiry_service.dart`)

Automatically checks and updates expired tasks.

#### **How It Works:**

1. **On Every Load:** Checks if tasks have passed their due date
2. **Marks Expired:** Adds metadata flag `isExpired: true`
3. **Updates Dashboard:** Moves count from status to expired
4. **Smart Detection:** Only active tasks (pending/checked-in) can expire

#### **Task Metadata When Expired:**
```json
{
  "metadata": {
    "isExpired": true,
    "expiredAt": "2025-10-21T10:30:00Z"
  }
}
```

#### **Key Methods:**

- `checkAndUpdateExpiredTasks()` - Check all user tasks
- `checkAndUpdateSingleTask(id)` - Check one task
- `isTaskExpired(dueDate, status)` - Helper to check expiry
- `getExpiredTasksCount()` - Count expired tasks

---

## 🔄 Automatic Count Updates

### **When Task is Created:**
```dart
// In createTask()
await dashboardService.incrementCount(task.status, isExpired: isExpired);
```

**Result:**
- ✅ `total` +1
- ✅ `pending` +1 (or appropriate status)

---

### **When Task Status Changes (e.g., Pending → Completed):**
```dart
// In updateTask()
await dashboardService.updateStatusCounts(
  oldStatus: TaskStatus.pending,
  newStatus: TaskStatus.completed,
  wasExpired: false,
  isExpired: false,
);
```

**Result:**
- ✅ `pending` -1
- ✅ `completed` +1
- ✅ `total` stays the same

---

### **When Task is Deleted:**
```dart
// In deleteTask()
await dashboardService.decrementCount(task.status, isExpired: isExpired);
```

**Result:**
- ✅ `total` -1
- ✅ `pending` -1 (or appropriate status)

---

### **When Task Becomes Expired:**
```dart
// Automatically in checkAndUpdateExpiredTasks()
await dashboardService.updateStatusCounts(
  oldStatus: TaskStatus.pending,
  newStatus: TaskStatus.pending, // Status stays same
  wasExpired: false,
  isExpired: true,
);
```

**Result:**
- ✅ `pending` -1
- ✅ `expired` +1
- ✅ `total` stays the same
- ✅ Task keeps original status but has `isExpired` flag

---

## 📝 Integration Points

### **1. Task Remote DataSource**

Updated to integrate both services:

```dart
@LazySingleton(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final DashboardService dashboardService;
  final TaskExpiryService taskExpiryService;
  
  // Constructor receives both services via DI
}
```

#### **Modified Methods:**

**`getTasks()`**
```dart
Future<List<TaskModel>> getTasks() async {
  // Check expired tasks first
  await taskExpiryService.checkAndUpdateExpiredTasks();
  
  // Then fetch tasks
  final allTasks = await _fetchAndDeduplicateTasks();
  return allTasks;
}
```

**`getTasksPage()`**
```dart
Future<TaskPageModel> getTasksPage(...) async {
  // Check expired tasks first
  await taskExpiryService.checkAndUpdateExpiredTasks();
  
  // Then fetch and paginate
  final allTasks = await _fetchAndDeduplicateTasks();
  // ... pagination logic
}
```

**`getTaskById()`**
```dart
Future<TaskModel> getTaskById(String id) async {
  // Check this specific task
  await taskExpiryService.checkAndUpdateSingleTask(id);
  
  // Then fetch
  final doc = await firestore.collection('tasks').doc(id).get();
  return TaskModel.fromFirestore(doc.data()!);
}
```

**`createTask()`**
```dart
Future<TaskModel> createTask(TaskModel task) async {
  // Create task
  await docRef.set(taskWithId.toFirestore());
  
  // Update dashboard
  final isExpired = taskExpiryService.isTaskExpired(
    task.dueDateTime, 
    task.status
  );
  await dashboardService.incrementCount(task.status, isExpired: isExpired);
  
  return taskWithId;
}
```

**`updateTask()`**
```dart
Future<TaskModel> updateTask(TaskModel task) async {
  // Get old task to compare
  final oldTask = await getTaskById(task.id);
  
  // Update task
  await firestore.collection('tasks').doc(task.id).update(...);
  
  // If status changed, update dashboard
  if (oldTask.status != task.status) {
    await dashboardService.updateStatusCounts(
      oldStatus: oldTask.status,
      newStatus: task.status,
      wasExpired: wasExpired,
      isExpired: isExpired,
    );
  }
  
  return task;
}
```

**`deleteTask()`**
```dart
Future<void> deleteTask(String id) async {
  // Get task to know its status
  final task = await getTaskById(id);
  
  // Delete task
  await firestore.collection('tasks').doc(id).delete();
  
  // Update dashboard
  await dashboardService.decrementCount(task.status, isExpired: isExpired);
}
```

**`checkInTask()` / `completeTask()`**
```dart
Future<TaskModel> completeTask(...) async {
  final task = await getTaskById(id);
  
  // Complete task
  await firestore.collection('tasks').doc(id).update(...);
  
  // Update dashboard (status change)
  await dashboardService.updateStatusCounts(
    oldStatus: task.status,
    newStatus: TaskStatus.completed,
    wasExpired: wasExpired,
    isExpired: false, // Completed tasks are never expired
  );
  
  return updatedTask;
}
```

---

## 🔒 Firestore Security Rules

Added rules for the dashboard collection:

```javascript
// ========== DASHBOARD COLLECTION ==========
match /dashboard/{userId} {
  // Users can only read their own dashboard
  allow read: if isAuthenticated() && isOwner(userId);
  
  // Users can write their own dashboard
  allow write: if isAuthenticated() && isOwner(userId);
}
```

---

## 📊 Usage Examples

### **Example 1: Initialize Dashboard on Login**

```dart
// In login success handler
await getIt<DashboardService>().initializeDashboard();
await getIt<DashboardService>().recalculateAllCounts();
```

### **Example 2: Watch Dashboard Counts**

```dart
// In a widget
StreamBuilder<Map<String, int>>(
  stream: dashboardService.watchDashboard(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    
    final counts = snapshot.data!;
    return Column(
      children: [
        Text('Total: ${counts['total']}'),
        Text('Pending: ${counts['pending']}'),
        Text('Checked In: ${counts['checkedIn']}'),
        Text('Completed: ${counts['completed']}'),
        Text('Expired: ${counts['expired']}'),
      ],
    );
  },
)
```

### **Example 3: Get Counts Once**

```dart
final counts = await dashboardService.getDashboard();
print('You have ${counts['pending']} pending tasks');
print('You have ${counts['expired']} expired tasks');
```

### **Example 4: Manual Expiry Check**

```dart
// Force check for expired tasks
await taskExpiryService.checkAndUpdateExpiredTasks();

// Get count of expired tasks
final expiredCount = await taskExpiryService.getExpiredTasksCount();
print('Found $expiredCount expired tasks');
```

---

## 🧪 Testing Scenarios

### **Test 1: Create Task**
1. Create a new task (status: pending)
2. **Expected:**
   - Task created in Firestore ✅
   - Dashboard `total` +1 ✅
   - Dashboard `pending` +1 ✅

### **Test 2: Complete Task**
1. Have a pending task
2. Complete the task
3. **Expected:**
   - Task status = completed ✅
   - Dashboard `pending` -1 ✅
   - Dashboard `completed` +1 ✅
   - Dashboard `total` stays same ✅

### **Test 3: Task Becomes Expired**
1. Have a task with due date in the past
2. Load task list
3. **Expected:**
   - Expiry check runs automatically ✅
   - Task has `metadata.isExpired: true` ✅
   - Dashboard `pending` -1 ✅
   - Dashboard `expired` +1 ✅
   - Task still shows original status ✅

### **Test 4: Delete Task**
1. Delete a pending task
2. **Expected:**
   - Task deleted from Firestore ✅
   - Dashboard `total` -1 ✅
   - Dashboard `pending` -1 ✅

### **Test 5: Check-In Task**
1. Check in to a pending task
2. **Expected:**
   - Task status = checked_in ✅
   - Dashboard `pending` -1 ✅
   - Dashboard `checkedIn` +1 ✅

---

## 🔍 How Expiry Works

### **Expiry Logic:**
```dart
bool isExpired = dueDate.isBefore(now) && 
                 status != TaskStatus.completed &&
                 status != TaskStatus.cancelled;
```

### **What Gets Marked Expired:**
- ✅ Pending tasks past due date
- ✅ Checked-in tasks past due date
- ❌ Completed tasks (never expired)
- ❌ Cancelled tasks (never expired)
- ❌ Checked-out tasks (excluded from counts)

### **Automatic Checks Happen:**
- ✅ On `getTasks()` - Full task list load
- ✅ On `getTasksPage()` - Paginated load
- ✅ On `getTaskById()` - Individual task load
- ✅ On app startup (if you call it)
- ✅ On pull-to-refresh (if implemented)

---

## 📈 Performance Considerations

### **Batch Updates:**
The expiry service uses batch writes for efficiency:
```dart
final batch = firestore.batch();
for (final task in expiredTasks) {
  batch.update(task.reference, {...});
}
await batch.commit(); // One network call
```

### **Dashboard Updates:**
Uses Firestore `FieldValue.increment()` for atomic updates:
```dart
await dashboardRef.update({
  'pending': FieldValue.increment(-1),
  'expired': FieldValue.increment(1),
});
```

### **Caching:**
- Dashboard is lightweight (just numbers)
- Can be cached locally for offline viewing
- Updates are incremental (no full recalculation)

---

## 🚨 Error Handling

### **Fallback Mechanism:**
If dashboard update fails, it automatically recalculates:
```dart
try {
  await dashboardService.incrementCount(status);
} catch (e) {
  // Initialize if doesn't exist
  await dashboardService.initializeDashboard();
  await dashboardService.recalculateAllCounts();
}
```

### **Graceful Degradation:**
- If expiry check fails, tasks still load
- If dashboard update fails, task operation succeeds
- All dashboard operations are logged

---

## 📝 Files Modified/Created

### **New Files:**
1. `lib/core/services/dashboard_service.dart` - Dashboard management
2. `lib/core/services/task_expiry_service.dart` - Expiry detection
3. `DASHBOARD_EXPIRY_IMPLEMENTATION.md` - This documentation

### **Modified Files:**
1. `lib/features/tasks/data/datasources/task_remote_datasource.dart`
   - Added dashboard & expiry service integration
   - Updated all CRUD methods
2. `firestore.rules`
   - Added dashboard collection rules

### **Auto-Generated:**
- `lib/injection_container.config.dart` - DI registration

---

## 🎉 Benefits

1. **Accurate Counts** - Always show correct task counts per status
2. **Real-Time Updates** - Dashboard updates instantly on changes
3. **Automatic Expiry** - No manual checking needed
4. **Scalable** - Works with thousands of tasks
5. **Offline-Ready** - Can cache dashboard locally
6. **Transparent** - All updates logged for debugging
7. **Atomic Operations** - No race conditions with increments

---

## 🚀 Next Steps (Optional Enhancements)

1. **Local Dashboard Cache** - Store counts in SQLite for offline viewing
2. **Dashboard Widget** - Display counts on home screen
3. **Notification on Expiry** - Alert user when tasks expire
4. **Weekly Reports** - Summarize completed vs expired tasks
5. **Charts/Graphs** - Visualize task distribution

---

## 🎯 Summary

**Problem:** Completed count always showing 0, no expiry detection  
**Solution:** 
- Created dashboard collection with real-time count tracking
- Automatic expiry detection on every load
- Integrated with all task operations

**Result:** 
- ✅ Accurate task counts by status
- ✅ Automatic expiry detection and marking
- ✅ Real-time dashboard updates
- ✅ Clean, maintainable architecture

---

**Status: READY FOR TESTING** 🚀

Test the app and watch the dashboard counts update in real-time as you create, update, complete, and delete tasks!
