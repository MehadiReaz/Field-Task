# Deployment Guide - Area-Based Task Management

## 🚀 Quick Deployment Steps

### 1. Update Dependencies
```bash
flutter pub get
```

### 2. Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### 3. Test the App
```bash
flutter run
```

## ⚠️ Important Notes

### Existing Users
If you have existing users in your database, they won't have a `selectedAreaId`. Here's what happens:

1. **On Login**: They will see the area selection dialog (required)
2. **Cannot Proceed**: Until they select an area
3. **Tasks Won't Show**: Until area is selected

### Migration Script (Optional)
If you want to assign a default area to all existing users:

```javascript
// Run this in Firebase Console > Firestore > Run Query
const admin = require('firebase-admin');
const db = admin.firestore();

async function migrateUsers() {
  const DEFAULT_AREA_ID = 'your-default-area-id'; // Replace with actual area ID
  
  const users = await db.collection('users').get();
  const batch = db.batch();
  
  users.docs.forEach(doc => {
    if (!doc.data().selectedAreaId) {
      batch.update(doc.ref, {
        selectedAreaId: DEFAULT_AREA_ID,
        updatedAt: new Date().toISOString()
      });
    }
  });
  
  await batch.commit();
  console.log('Migration complete!');
}

migrateUsers();
```

### Update Existing Tasks
If you have existing tasks without `areaId`:

```javascript
// Run this in Firebase Console > Firestore > Run Query
const admin = require('firebase-admin');
const db = admin.firestore();

async function migrateTasks() {
  const DEFAULT_AREA_ID = 'your-default-area-id'; // Replace with actual area ID
  
  const tasks = await db.collection('tasks').get();
  const batch = db.batch();
  
  tasks.docs.forEach(doc => {
    if (!doc.data().areaId) {
      batch.update(doc.ref, {
        areaId: DEFAULT_AREA_ID,
        updatedAt: new Date().toISOString()
      });
    }
  });
  
  await batch.commit();
  console.log('Migration complete!');
}

migrateTasks();
```

## 🧪 Testing Checklist

### Before Deployment
- [ ] Run `flutter analyze` - should show no errors
- [ ] Test login with Google
- [ ] Test login with email
- [ ] Test area selection on first login
- [ ] Test creating a task
- [ ] Test viewing tasks filtered by area
- [ ] Test changing area in profile
- [ ] Test logout

### After Deployment
- [ ] Deploy Firestore rules
- [ ] Test with real users
- [ ] Monitor Firebase Console for errors
- [ ] Check Firestore queries are efficient

## 🐛 Troubleshooting

### Issue: "No areas available" on first login
**Solution**: 
1. Go to Areas page (bottom navigation)
2. Create at least one area
3. Try logging in again

### Issue: Tasks not showing
**Solution**:
1. Check if user has selected an area (Profile page)
2. Create a task and verify it has areaId set
3. Check Firestore rules are deployed correctly

### Issue: Cannot create tasks
**Solution**:
1. Verify user has selectedAreaId
2. Check Firebase Console logs for rule violations
3. Verify areaId is being set in task creation

## 📱 User Instructions

### For New Users
1. Login with your credentials
2. **Select an area** from the list (required)
3. Start creating and viewing tasks

### For Existing Users
1. Login as usual
2. If prompted, **select your working area**
3. Your tasks will now be filtered by area

### Changing Your Area
1. Go to Profile (bottom right icon)
2. Scroll to "Work Area" section
3. Tap "Change" button
4. Select new area
5. Task list will update automatically

## 🎯 What Users Will See

### First Login (New Users)
1. Login screen
2. **Area Selection Dialog** (Cannot dismiss)
   - Shows all available areas
   - Must select one to continue
3. Home screen with tasks

### Returning Users (No Area)
1. Login screen
2. **Area Selection Dialog** (Cannot dismiss)
3. Home screen with tasks

### Returning Users (Has Area)
1. Login screen
2. Home screen with tasks (filtered by their area)

## 📊 Monitoring

### Firebase Console - Firestore
- Watch for rule violations
- Monitor query performance
- Check if indexes are needed

### App Logs
Look for these messages:
- `✅ User document created/updated`
- `✅ Fetched X tasks for area: Y`
- `✅ Watching X tasks for area: Y`
- `⚠️ User has no selected area`

## 🔒 Security Verification

### Test These Scenarios:
1. **User A in Area 1**:
   - Can create tasks in Area 1 ✅
   - Cannot create tasks in Area 2 ❌
   - Can see tasks in Area 1 ✅
   - Cannot see tasks in Area 2 ❌

2. **User changes area**:
   - Old area tasks disappear ✅
   - New area tasks appear ✅
   - Can create tasks in new area ✅

3. **Firestore Rules**:
   - Try to read tasks from other area (should fail) ❌
   - Try to create task in different area (should fail) ❌

## 📞 Support

If you encounter any issues:
1. Check Firebase Console logs
2. Check app logs for error messages
3. Verify Firestore rules are deployed
4. Check user has selectedAreaId
5. Verify area exists and is active

## ✅ Success Criteria

Your deployment is successful when:
- ✅ New users see area selection dialog
- ✅ Users cannot proceed without selecting area
- ✅ Tasks are filtered by selected area
- ✅ Users can change areas
- ✅ Task list updates when area changes
- ✅ Security rules enforce area-based access
- ✅ No unauthorized access to other areas' tasks

---

**Deployment completed successfully!** 🎉

For questions or issues, refer to:
- `IMPLEMENTATION_COMPLETE.md` - Full implementation details
- `AREA_BASED_FILTERING_IMPLEMENTATION.md` - Technical details
