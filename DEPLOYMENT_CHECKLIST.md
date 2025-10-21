# ✅ Deployment Checklist

## Pre-Deployment

- [x] Dashboard service created
- [x] Task expiry service created
- [x] Remote datasource integrated
- [x] Auth bloc updated
- [x] Firestore rules updated
- [x] Build runner executed successfully
- [x] No compilation errors

## Deployment Steps

### 1. Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```
**Expected:** Rules deployed successfully, dashboard collection accessible

### 2. Test Login
- [ ] Login to app
- [ ] Check console logs for "Dashboard initialized"
- [ ] Open Firebase Console → Firestore
- [ ] Verify `dashboard/{userId}` document created
- [ ] All counts should be 0 (or calculated from existing tasks)

### 3. Test Create Task
- [ ] Create a new task (status: pending)
- [ ] Check Firebase Console → `dashboard/{userId}`
- [ ] Verify: `total` increased by 1
- [ ] Verify: `pending` increased by 1

### 4. Test Complete Task
- [ ] Complete a pending task
- [ ] Check Firebase Console → `dashboard/{userId}`
- [ ] Verify: `total` stays same
- [ ] Verify: `pending` decreased by 1
- [ ] Verify: `completed` increased by 1

### 5. Test Check-In
- [ ] Check-in to a pending task
- [ ] Check Firebase Console → `dashboard/{userId}`
- [ ] Verify: `pending` decreased by 1
- [ ] Verify: `checkedIn` increased by 1

### 6. Test Delete Task
- [ ] Delete a task
- [ ] Check Firebase Console → `dashboard/{userId}`
- [ ] Verify: `total` decreased by 1
- [ ] Verify: Appropriate status count decreased by 1

### 7. Test Expiry Detection
- [ ] Create a task with past due date (e.g., yesterday)
- [ ] Close and reopen app (or pull to refresh)
- [ ] Check Firebase Console → `tasks/{taskId}`
- [ ] Verify: `metadata.isExpired` = true
- [ ] Verify: `metadata.expiredAt` has timestamp
- [ ] Check `dashboard/{userId}`
- [ ] Verify: Status count decreased by 1
- [ ] Verify: `expired` increased by 1

### 8. Test Real-Time Updates
- [ ] Open Firebase Console → Firestore → `dashboard/{userId}`
- [ ] Keep it open
- [ ] Create/update/delete tasks in app
- [ ] Verify: Counts update in real-time in Firebase Console

## Verification

### Check Logs
Look for these messages in console:
```
[INFO] Dashboard initialized for user: {userId}
[INFO] Dashboard recalculated: total=X, pending=Y, ...
[INFO] Updated counts: pending → completed
[WARNING] Marked task as expired: {taskId} (was pending)
```

### Check Firestore Structure
```
/dashboard
  /{userId}
    - userId: string
    - total: number
    - pending: number
    - checkedIn: number
    - completed: number
    - expired: number
    - cancelled: number
    - lastUpdated: timestamp

/tasks
  /{taskId}
    - status: string
    - dueDate: string
    - metadata: map
      - isExpired: boolean (optional)
      - expiredAt: string (optional)
```

## Troubleshooting

### Issue: Dashboard not created
**Solution:**
```dart
// Run manually in code
await getIt<DashboardService>().initializeDashboard();
await getIt<DashboardService>().recalculateAllCounts();
```

### Issue: Counts incorrect
**Solution:**
```dart
// Force recalculation
await getIt<DashboardService>().recalculateAllCounts();
```

### Issue: Expiry not working
**Check:**
- [ ] Task has `dueDate` field (not null)
- [ ] Due date is in the past
- [ ] Task status is `pending` or `checked_in`
- [ ] `getTasks()` or `getTasksPage()` was called

**Manual trigger:**
```dart
await getIt<TaskExpiryService>().checkAndUpdateExpiredTasks();
```

### Issue: Permission denied
**Check:**
- [ ] Firestore rules deployed
- [ ] User is authenticated
- [ ] User is accessing their own dashboard document

## Success Criteria

✅ Dashboard document created on login  
✅ Counts update on task creation  
✅ Counts update on status change  
✅ Counts update on deletion  
✅ Expired tasks detected automatically  
✅ Expired tasks flagged in metadata  
✅ Dashboard counts include expired count  
✅ Real-time updates work  
✅ No errors in console  

## Performance Check

- [ ] Dashboard operations don't block UI
- [ ] Expiry check completes in < 2 seconds
- [ ] Task operations complete in < 1 second
- [ ] No noticeable lag when creating/updating tasks

## Final Verification

```bash
# Check for errors
flutter analyze

# Run the app
flutter run
```

### Test Flow:
1. Login → Dashboard initialized ✅
2. Create 3 pending tasks → total=3, pending=3 ✅
3. Complete 1 task → total=3, pending=2, completed=1 ✅
4. Check-in to 1 task → pending=1, checkedIn=1, completed=1 ✅
5. Delete completed task → total=2, checkedIn=1, pending=1 ✅
6. Create expired task → After reload: total=3, expired=1 ✅

---

## 🎉 When All Checked

The system is fully functional! 

**Features:**
- ✅ Real-time dashboard counts
- ✅ Automatic expiry detection
- ✅ Accurate count tracking
- ✅ Works offline and online

**Ready for production use!**
