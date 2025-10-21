# 🚀 Quick Start Guide - Dashboard & Expiry System

## Setup Instructions

### Step 1: Deploy Firestore Rules

Deploy the updated security rules that include dashboard collection:

```bash
firebase deploy --only firestore:rules
```

### Step 2: Initialize Dashboard on Login

Add this code to initialize the dashboard when a user logs in:

**File:** `lib/features/auth/presentation/bloc/auth_bloc.dart` (or wherever login succeeds)

```dart
// After successful login
await getIt<DashboardService>().initializeDashboard();
await getIt<DashboardService>().recalculateAllCounts();
```

### Step 3: Test the System

1. **Login to the app**
2. **Create a few tasks** with different statuses
3. **Open Firebase Console** → Firestore Database
4. **Check the `dashboard` collection**
5. You should see your user's document with counts:

```json
{
  "userId": "abc123",
  "total": 5,
  "pending": 3,
  "checkedIn": 1,
  "completed": 1,
  "expired": 0,
  "cancelled": 0,
  "lastUpdated": "2025-10-21T..."
}
```

### Step 4: Test Expiry Detection

1. **Create a task with a past due date** (e.g., yesterday)
2. **Leave the app and return** (triggers getTasks())
3. **Check the task in Firestore**
4. It should have:
   ```json
   {
     "status": "pending", // Original status preserved
     "metadata": {
       "isExpired": true,
       "expiredAt": "2025-10-21T..."
     }
   }
   ```
5. **Check dashboard** - expired count should increase

---

## 🎨 UI Integration (Optional)

### Display Dashboard Counts

Create a stats widget in your home page:

```dart
import 'package:flutter/material.dart';
import 'package:task_trackr/core/services/dashboard_service.dart';
import 'package:task_trackr/injection_container.dart';

class TaskStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashboardService = getIt<DashboardService>();
    
    return StreamBuilder<Map<String, int>>(
      stream: dashboardService.watchDashboard(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        
        final counts = snapshot.data!;
        
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Task Overview', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                _buildStatRow('Total Tasks', counts['total']!, Colors.blue),
                _buildStatRow('Pending', counts['pending']!, Colors.orange),
                _buildStatRow('Checked In', counts['checkedIn']!, Colors.green),
                _buildStatRow('Completed', counts['completed']!, Colors.teal),
                _buildStatRow('Expired', counts['expired']!, Colors.red),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Show Expired Badge on Tasks

In your task list item widget:

```dart
// Check if task is expired
final isExpired = (task.metadata?['isExpired'] as bool?) ?? false;

// Show badge
if (isExpired) {
  Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      'EXPIRED',
      style: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  )
}
```

---

## 🔧 Troubleshooting

### Issue: Dashboard shows 0 for all counts

**Solution:**
```dart
// Force recalculation
await dashboardService.recalculateAllCounts();
```

### Issue: Expiry not detecting

**Check:**
1. Task has `dueDate` field set
2. Task status is `pending` or `checked_in`
3. Due date is in the past
4. Called `getTasks()` or `getTasksPage()` to trigger check

**Manual check:**
```dart
await taskExpiryService.checkAndUpdateExpiredTasks();
```

### Issue: Counts not updating

**Check:**
1. User is authenticated
2. Firestore rules deployed
3. No errors in console
4. Dashboard collection exists in Firestore

**View logs:**
All operations are logged with `AppLogger`:
```dart
import 'package:task_trackr/core/utils/logger.dart';
AppLogger.enableDebugLogs();
```

---

## 📊 Monitoring

### Check Dashboard in Firebase Console

1. Open Firebase Console
2. Go to Firestore Database
3. Navigate to `dashboard` collection
4. Find your user ID document
5. View real-time counts

### Check Expired Tasks

Query expired tasks in Firestore:
```
Collection: tasks
Filter: metadata.isExpired == true
```

---

## ✅ Verification Checklist

- [ ] Firebase rules deployed
- [ ] Dashboard initialized on login
- [ ] Create task → counts increase
- [ ] Update task status → counts adjust correctly
- [ ] Delete task → counts decrease
- [ ] Complete task → pending -1, completed +1
- [ ] Expired task detected → moved to expired count
- [ ] Dashboard widget shows real-time counts
- [ ] No errors in console

---

## 📞 Support

If you encounter issues:

1. Check logs: `AppLogger.info()`, `.error()`, `.warning()`
2. Verify Firestore rules: `firebase deploy --only firestore:rules`
3. Force recalculation: `dashboardService.recalculateAllCounts()`
4. Check network connectivity
5. Verify user is authenticated

---

**System Status:** ✅ READY TO USE

All components are implemented and integrated. Just deploy the rules and initialize the dashboard on login!
