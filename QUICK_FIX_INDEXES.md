# Quick Fix: Create Firestore Indexes Manually

## The Problem
The indexes are still building or weren't created properly. You need to create them manually in Firebase Console.

## Quick Solution - Click These Links

### Link 1: Create Index for Pending Status
Click this link to auto-create the index:
```
https://console.firebase.google.com/v1/r/project/tasktrackr-f106e/firestore/indexes?create_composite=Ck5wcm9qZWN0cy90YXNrdHJhY2tyLWYxMDZlL2RhdGFiYXNlcy8oZGVmYXVsdCkvY29sbGVjdGlvbkdyb3Vwcy90YXNrcy9pbmRleGVzL18QARoOCgphc3NpZ25lZFRvEAEaCgoGc3RhdHVzEAEaCwoHZHVlRGF0ZRABGgwKCF9fbmFtZV9fEAE
```

### Link 2: Check All Indexes
Go to Firebase Console to check index status:
```
https://console.firebase.google.com/project/tasktrackr-f106e/firestore/indexes
```

## Step-by-Step Instructions

1. **Click Link 1** above (or copy from the error message)
2. You'll be taken to Firebase Console with the index pre-configured
3. Click **"Create Index"** button
4. Wait 2-5 minutes for the index to build
5. Test the filter again

## What to Look For

In Firebase Console > Firestore > Indexes, you should see:

### Status Indicators:
- 🟡 **Building** - Wait a few more minutes
- 🟢 **Enabled** - Ready! Test your filters
- 🔴 **Error** - Check the error message

### Required Indexes:
You need these composite indexes for the filters to work:

1. ✅ `assignedTo` (Ascending) + `status` (Ascending) + `dueDate` (Ascending)
2. ✅ `assignedTo` (Ascending) + `status` (Ascending) + `dueDate` (Descending)

## Alternative: Wait for Automatic Build

If you don't want to click the link, just wait 5-10 minutes. The indexes deployed via:
```bash
firebase deploy --only firestore:indexes
```
will be built automatically.

## Verify It's Working

Once indexes show "Enabled":
1. Restart your app
2. Try filtering by Pending
3. Check logcat - no more FAILED_PRECONDITION errors

## Why This Happens

Firestore requires indexes to be **built** before use, not just deployed. Building takes time:
- Small database: 2-5 minutes
- Medium database: 5-10 minutes  
- Large database: 10+ minutes

The `firebase deploy` command triggers the build, but doesn't wait for completion.
