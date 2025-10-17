
## 🔄 **USER FLOWS**

### **Flow 1: First-Time User Registration**
```
1. User opens app
   ↓
2. Splash Screen (check auth state)
   ↓
3. Login Screen
   ↓
4. User taps "Sign in with Google"
   ↓
5. Google Sign-In flow
   ↓
6. Create user document in Firestore
   - id: Firebase Auth UID
   - email, displayName, photoUrl from Google
   - role: agent (default)
   - createdAt: now
   ↓
7. Save auth token locally
   ↓
8. Navigate to Task List Screen
   ↓
9. Request location permissions
   ↓
10. Fetch assigned tasks from Firestore
    ↓
11. Cache tasks in Drift database
    ↓
12. Display tasks
```

### **Flow 2: Returning User (Auto-Login)**
```
1. User opens app
   ↓
2. Splash Screen
   ↓
3. Check local auth token
   ↓
4. Token valid?
   ├─ YES → Navigate to Task List
   └─ NO → Navigate to Login Screen
   ↓
5. Check network status
   ├─ ONLINE → Sync with Firestore
   └─ OFFLINE → Load from local DB
   ↓
6. Display tasks
```

### **Flow 3: Create Task**
```
1. User taps FAB on Task List
   ↓
2. Navigate to Create Task Screen
   ↓
3. User fills form:
   - Title (required)
   - Description
   - Due date/time (picker)
   - Priority (dropdown)
   ↓
4. User taps "Select Location"
   ↓
5. Navigate to Map Selection Screen
   ↓
6. User drags marker or taps location
   ↓
7. Reverse geocode to get address
   ↓
8. User confirms location
   ↓
9. Return to Create Task Screen
   ↓
10. User taps "Save"
    ↓
11. Validate form
    ↓
12. Check network status
    ├─ ONLINE:
    │   - Save to Firestore
    │   - Get document ID
    │   - Save to local DB with synced status
    │   - Show success message
    │
    └─ OFFLINE:
        - Generate temp ID
        - Save to local DB with pending status
        - Add to sync queue
        - Show "Will sync when online" message
    ↓
13. Navigate back to Task List
    ↓
14. Task appears in list
```

### **Flow 4: Check-In to Task**
```
1. User taps task card
   ↓
2. Navigate to Task Detail Screen
   ↓
3. App gets current location
   ↓
4. Calculate distance from task location
   ↓
5. Display distance with color indicator
   ↓
6. Check conditions for "Check-In" button:
   - Task status is "pending"
   - Distance <= 100m
   - User is assigned agent
   ↓
7. Button state:
   ├─ Enabled (all conditions met)
   └─ Disabled (show reason)
   ↓
8. User taps "Check-In"
   ↓
9. Show confirmation dialog
   ↓
10. Update task:
    - status = checkedIn
    - checkedInAt = now
    - Update in Firestore (if online)
    - Update in local DB
    - Add to sync queue (if offline)
    ↓
11. Show success message
    ↓
12. Update UI with new status
    ↓
13. Enable "Complete Task" button
```

### **Flow 5: Complete Task**
```
1. User is on Task Detail Screen
   ↓
2. Task is checked-in
   ↓
3. User is within 100m
   ↓
4. User taps "Complete Task"
   ↓
5. Show completion dialog:
   - Optional completion notes
   - Optional photo upload
   ↓
6. User confirms completion
   ↓
7. Update task:
   - status = completed
   - completedAt = now
   - completionNotes
   - Upload photo to Firebase Storage (if provided)
   - Update in Firestore (if online)
   - Update in local DB
   - Add to sync queue (if offline)
   ↓
8. Show success animation
   ↓
9. Navigate back to Task List
   ↓
10. Task appears in "Completed" filter
```

### **Flow 6: Offline Operation & Sync**
```
SCENARIO: User is offline

1. User creates/updates task
   ↓
2. Save to local DB immediately
   ↓
3. Add operation to sync_queue table
   ↓
4. Show "Offline - Will sync later" indicator
   ↓
5. User continues working offline

---

WHEN NETWORK RETURNS:

1. App detects network change
   ↓
2. SyncBloc triggered
   ↓
3. Process sync_queue (oldest first)
   ↓
4. For each queued operation:
   ├─ CREATE: Push to Firestore → Get server ID → Update local ID
   ├─ UPDATE: Push changes to Firestore
   └─ DELETE: Delete from Firestore
   ↓
5. On success:
   - Remove from sync_queue
   - Update syncStatus to "synced"
   ↓
6. On failure:
   - Increment retryCount
   - Schedule retry with exponential backoff
   ↓
7. Fetch latest data from Firestore
   ↓
8. Merge with local data (server wins)
   ↓
9. Update UI
   ↓
10. Show "Synced" message
```

### **Flow 7: Location Permission Flow**
```
1. App needs location
   ↓
2. Check permission status
   ↓
3. Status?
   ├─ GRANTED → Get location
   │
   ├─ DENIED → Show permission rationale dialog
   │   ↓
   │   User taps "Grant"
   │   ↓
   │   Request permission
   │   ↓
   │   If granted → Get location
   │   If denied → Show "Go to Settings" option
   │
   └─ PERMANENTLY DENIED
       ↓
       Show dialog: "Please enable location in Settings"
       ↓
       Button to open app settings
```