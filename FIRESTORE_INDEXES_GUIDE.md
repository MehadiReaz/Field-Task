# Firestore Index Configuration

## Issue
The filter feature required composite indexes for Firestore queries that filter by multiple fields and order by another field.

## Error Messages
```
Listen for Query(target=Query(tasks where assignedTo==XXX and status==completed order by dueDate, __name__)
failed: Status{code=FAILED_PRECONDITION, description=The query requires an index.
```

## Solution
Added composite indexes to `firestore.indexes.json` for the following query patterns:

### Index 1: assignedTo + status + dueDate (Ascending)
```json
{
  "collectionGroup": "tasks",
  "queryScope": "Collection",
  "fields": [
    { "fieldPath": "assignedTo", "order": "Ascending" },
    { "fieldPath": "status", "order": "Ascending" },
    { "fieldPath": "dueDate", "order": "Ascending" },
    { "fieldPath": "__name__", "order": "Ascending" }
  ]
}
```

### Index 2: assignedTo + status + dueDate (Descending)
```json
{
  "collectionGroup": "tasks",
  "queryScope": "Collection",
  "fields": [
    { "fieldPath": "assignedTo", "order": "Ascending" },
    { "fieldPath": "status", "order": "Ascending" },
    { "fieldPath": "dueDate", "order": "Descending" },
    { "fieldPath": "__name__", "order": "Descending" }
  ]
}
```

## Why These Indexes Are Needed

Firestore requires composite indexes when:
1. Filtering by multiple equality fields (`assignedTo` and `status`)
2. Ordering by a different field (`dueDate`)

Our filter queries do exactly this:
```dart
firestore
  .collection('tasks')
  .where('assignedTo', isEqualTo: userId)
  .where('status', isEqualTo: status)
  .orderBy('dueDate', descending: false)
```

## Deployment

Indexes were deployed using:
```bash
firebase deploy --only firestore:indexes
```

## Index Build Status

After deployment, Firestore will build these indexes in the background. You can check the status at:
https://console.firebase.google.com/project/tasktrackr-f106e/firestore/indexes

**Note:** Index building can take a few minutes. During this time, queries may still fail until the indexes are fully built.

## Testing

Once indexes are built, test the filters:
1. ✅ Filter by Pending
2. ✅ Filter by Checked In
3. ✅ Filter by Completed
4. ✅ Filter by Expired

All filters should now work without the `FAILED_PRECONDITION` error.

## Future Considerations

If you add more filter combinations (e.g., priority + status), you'll need to add additional indexes.

The index configuration file is version-controlled and will be deployed with your app, ensuring consistency across environments.
