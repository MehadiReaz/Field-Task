# How to Add an Area in Firebase

## 📋 Prerequisites

- Access to Firebase Console
- Your Firebase project
- Know your user ID (from the users collection)
- Know a location for the area (latitude, longitude)

## 🚀 Step-by-Step Instructions

### Option 1: Using Firebase Console (Easiest)

1. **Go to Firebase Console**
   - Open https://console.firebase.google.com
   - Select your project (task-trackr)

2. **Navigate to Firestore Database**
   - Click on "Firestore Database" in the left sidebar
   - You should see collections listed

3. **Create/Open the `areas` Collection**
   - If it doesn't exist, click "Start collection"
   - Collection ID: `areas`
   - Click "Next"

4. **Add Your First Document**
   - Document ID: (auto-generate or use a custom ID like `area-banani-001`)
   - Add the following fields:

   | Field | Type | Value | Example |
   |-------|------|-------|---------|
   | `id` | String | (same as document ID) | `area-banani-001` |
   | `name` | String | Area name | `Banani Zone` |
   | `centerLatitude` | Number | Latitude | `23.7937` |
   | `centerLongitude` | Number | Longitude | `90.4066` |
   | `radiusInMeters` | Number | Radius in meters | `500` |
   | `description` | String | (optional) Area description | `Commercial area in Dhaka` |
   | `isActive` | Boolean | `true` or `false` | `true` |
   | `createdById` | String | Your user ID | (get from users collection) |
   | `createdByName` | String | Your display name | `John Doe` |
   | `createdAt` | Timestamp | Current timestamp | (now) |
   | `updatedAt` | Timestamp | Current timestamp | (now) |
   | `assignedAgentIds` | Array | Array of user IDs | `[]` (empty array for now) |

5. **Click "Save"**

### Option 2: Using Firestore Emulator (For Local Testing)

If you're using the Firebase emulator:

1. Open Firebase Emulator UI at `http://localhost:4000`
2. Navigate to Firestore tab
3. Create collection `areas`
4. Add document with the same fields as above

## 📍 Sample Area Data (Bangladesh)

Here are some pre-configured areas you can add:

### Area 1: Banani Zone
```
Document ID: area-banani-001
id: area-banani-001
name: Banani Zone
centerLatitude: 23.7937
centerLongitude: 90.4066
radiusInMeters: 500
description: Commercial area in Banani, Dhaka
isActive: true
createdById: (your user ID)
createdByName: Admin
createdAt: (current date)
updatedAt: (current date)
assignedAgentIds: [] (empty for now)
```

### Area 2: Gulshan Zone
```
Document ID: area-gulshan-001
id: area-gulshan-001
name: Gulshan Zone
centerLatitude: 23.8103
centerLongitude: 90.4125
radiusInMeters: 750
description: Business district in Gulshan
isActive: true
createdById: (your user ID)
createdByName: Admin
createdAt: (current date)
updatedAt: (current date)
assignedAgentIds: [] (empty for now)
```

### Area 3: Dhanmondi Zone
```
Document ID: area-dhanmondi-001
id: area-dhanmondi-001
name: Dhanmondi Zone
centerLatitude: 23.7612
centerLongitude: 90.3669
radiusInMeters: 600
description: Residential area in Dhanmondi
isActive: true
createdById: (your user ID)
createdByName: Admin
createdAt: (current date)
updatedAt: (current date)
assignedAgentIds: [] (empty for now)
```

## 🔍 How to Find Your User ID

1. Go to Firestore Database
2. Open the `users` collection
3. Look for your document (usually the one with your email)
4. Copy the Document ID - this is your user ID

## ✅ Verification Steps

After adding an area:

1. **In Firebase Console**
   - Go to Firestore > Collections > areas
   - Verify the area document appears
   - Check all fields are correct

2. **In the App**
   - Go to Areas page (bottom navigation)
   - Tap refresh if needed
   - Your area should appear in the list

3. **When Logging In**
   - Log in with your account
   - Area selection dialog should show your new area
   - Select it and proceed

## 🚨 Troubleshooting

### Area doesn't appear in the app

1. **Check Firestore Rules**
   - Make sure your user can read from `areas` collection
   - Check if `isActive` is set to `true`

2. **Refresh the App**
   - Go to Areas page and pull down to refresh
   - Or restart the app

3. **Check Timestamps**
   - Make sure `createdAt` and `updatedAt` are valid timestamps
   - Firebase uses ISO 8601 format or Timestamp type

### Error when selecting area

1. **Check your user ID**
   - Verify `selectedAreaId` is properly set
   - Check Firestore rules allow this

2. **Check app logs**
   - Look for error messages in Flutter console
   - Check Firebase Console logs

## 🔧 Advanced: Using Firebase CLI

If you prefer command line, you can add an area using a script:

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Set your Firebase project
firebase use task-trackr

# Add a document using Firestore CLI
firebase firestore:set areas/area-banani-001 --data '{
  "id": "area-banani-001",
  "name": "Banani Zone",
  "centerLatitude": 23.7937,
  "centerLongitude": 90.4066,
  "radiusInMeters": 500,
  "description": "Commercial area",
  "isActive": true,
  "createdById": "your-user-id",
  "createdByName": "Admin",
  "createdAt": "'$(date -u +'%Y-%m-%dT%H:%M:%SZ')'",
  "updatedAt": "'$(date -u +'%Y-%m-%dT%H:%M:%SZ')'",
  "assignedAgentIds": []
}'
```

## 🌍 Coordinates Reference

If you need other coordinates in Dhaka:

| Area | Latitude | Longitude |
|------|----------|-----------|
| Banani | 23.7937 | 90.4066 |
| Gulshan | 23.8103 | 90.4125 |
| Dhanmondi | 23.7612 | 90.3669 |
| Mirpur | 23.8147 | 90.3580 |
| Uttara | 23.8748 | 90.4090 |
| Motijheel | 23.7654 | 90.4082 |
| Farmgate | 23.7762 | 90.3803 |
| Airport Area | 23.8627 | 90.3673 |

## 📱 After Adding Areas

1. **Set as Your Selected Area**
   - The app will show the area in the selection dialog
   - Select it to set as your working area

2. **Create Tasks**
   - Tasks created will now be linked to this area
   - Only users with this area selected will see these tasks

3. **Manage Multiple Areas**
   - Add more areas using the same process
   - Switch between areas in the profile page

## 💡 Tips

- Use meaningful area names and descriptions
- Set appropriate radius values (100-1000 meters typically)
- Add multiple areas for better organization
- Assign agents to areas later via assignedAgentIds

---

**Need help?** Check the Firebase documentation or the app's DEPLOYMENT_GUIDE.md for more information.
