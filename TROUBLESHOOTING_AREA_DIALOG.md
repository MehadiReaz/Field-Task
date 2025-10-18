# Troubleshooting: Area Selection Dialog Not Showing

## Issue
After login, the console shows "⚠️ User has no selected area" but the area selection dialog doesn't appear.

## Solution Applied

### Changes Made:

1. **Added debug logging** in both `splash_page.dart` and `login_page.dart` to track:
   - When user is authenticated
   - Whether user has selectedAreaId
   - When dialog should show
   - Dialog result

2. **Added delay before showing dialog** (300ms) to ensure widget tree is built

3. **Added mounted checks** to prevent showing dialog on unmounted widgets

4. **Added imports** to login_page.dart for AreaBloc and AreaSelectionDialog

## How to Test

### 1. Clear existing user data (to simulate first login):
```dart
// In terminal or code
await secureStorage.deleteAll();
```

### 2. Run the app and login:
```bash
flutter run
```

### 3. Watch the console logs:
You should see logs like:
```
🔍 Login: User authenticated. SelectedAreaId: null
⚠️ Login: No area selected, showing dialog
📱 Login: Showing area selection dialog
```

### 4. Expected behavior:
- Area selection dialog appears
- User must select an area
- Cannot dismiss without selecting
- After selection, navigates to home

## Debug Logs to Look For

### When login succeeds with no area:
```
🔍 Login: User authenticated. SelectedAreaId: null
⚠️ Login: No area selected, showing dialog
📱 Login: Showing area selection dialog
✅ Login: Dialog result: true
✅ Login: Area selected, refreshing user and navigating to home
```

### When login succeeds with area already selected:
```
🔍 Login: User authenticated. SelectedAreaId: area123
✅ Login: User has area, navigating to home
```

### From splash page (on app restart):
```
🔍 Splash: User authenticated. SelectedAreaId: null
⚠️ Splash: No area selected, showing dialog
📱 Splash: Showing area selection dialog
```

## If Dialog Still Doesn't Show

### Check 1: User has selectedAreaId in Firestore
1. Open Firebase Console
2. Go to Firestore Database
3. Open users collection
4. Check your user document
5. Look for `selectedAreaId` field
6. If it exists and is not null, delete it to test

### Check 2: Areas exist in database
1. Go to Firestore Database
2. Check if `areas` collection has documents
3. If empty, create at least one area first

### Check 3: Dialog widget is properly created
The dialog should have:
- AreaBloc provider
- LoadAreasEvent triggered on init
- isRequired = true (cannot dismiss)

### Check 4: Check context
Make sure `mounted` is true before showing dialog:
```dart
if (!mounted) return;
await showDialog(...);
```

## Manual Test Steps

1. **Fresh install test**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Login with Google/Email**

3. **Expected**: Area selection dialog should appear

4. **Select an area**

5. **Expected**: Navigate to home page

6. **Logout** (from profile page)

7. **Login again**

8. **Expected**: Should go directly to home (area already selected)

## Additional Debug Code

Add this to area_selection_dialog.dart initState:
```dart
@override
void initState() {
  super.initState();
  print('🎨 AreaSelectionDialog: Widget created');
  context.read<AreaBloc>().add(const LoadAreasEvent());
}
```

Add this to area_bloc.dart LoadAreasEvent handler:
```dart
Future<void> _onLoadAreas(...) async {
  print('📋 AreaBloc: Loading areas...');
  emit(const AreaLoading());
  
  final result = await getAreas(NoParams());
  
  result.fold(
    (failure) {
      print('❌ AreaBloc: Error loading areas: ${failure.message}');
      emit(AreaError(failure.message));
    },
    (areas) {
      print('✅ AreaBloc: Loaded ${areas.length} areas');
      emit(AreasLoaded(areas));
    },
  );
}
```

## Quick Fix Commands

### Reset user's area in Firebase Console (Firestore):
```javascript
// Navigate to user document
db.collection('users').doc('USER_ID_HERE').update({
  selectedAreaId: firebase.firestore.FieldValue.delete()
});
```

### Reset local storage (in app):
```dart
// Add this as a button in settings page
await getIt<FlutterSecureStorage>().deleteAll();
```

## Success Indicators

✅ Console shows dialog creation logs
✅ Dialog appears on screen
✅ Areas list is loaded
✅ User can select an area
✅ After selection, navigates to home
✅ selectedAreaId is saved in Firestore
✅ On next login, goes directly to home

## Still Not Working?

Check these files have the correct imports:
- `lib/features/auth/presentation/pages/login_page.dart`
- `lib/features/auth/presentation/pages/splash_page.dart`

Required imports:
```dart
import '../../../../injection_container.dart';
import '../../../areas/presentation/bloc/area_bloc.dart';
import '../widgets/area_selection_dialog.dart';
```

## Testing Checklist

- [ ] Run `flutter clean && flutter pub get`
- [ ] Clear app data or reinstall
- [ ] Check Firebase Console - areas collection has documents
- [ ] Check Firebase Console - user document has no selectedAreaId
- [ ] Login and watch console logs
- [ ] Dialog appears
- [ ] Select area
- [ ] Navigate to home
- [ ] Check Firestore - user now has selectedAreaId
