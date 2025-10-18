# Fixed: UpdateUserArea Not Registered in GetIt

## Problem
The app was throwing a runtime error:
```
Bad state: GetIt: Object/factory with type UpdateUserArea is not registered inside GetIt.
```

This error occurred when the area selection dialog tried to update the user's selected area.

## Root Cause
The `UpdateUserArea` usecase was properly annotated with `@lazySingleton` but the dependency injection configuration file (`injection_container.config.dart`) hadn't been regenerated yet. This file is auto-generated and needs to be rebuilt when new injectable classes are added.

## Solution
Regenerated the dependency injection configuration by running the build runner:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This command:
1. Scanned all files for `@injectable` and `@lazySingleton` annotations
2. Found the `UpdateUserArea` usecase with `@lazySingleton` annotation
3. Added it to the generated configuration file
4. Registered it in the GetIt service locator

## Files Modified
1. `lib/injection_container.config.dart` - AUTO-GENERATED (added UpdateUserArea registration)

## What Was Added to Config
```dart
gh.lazySingleton<_i250.UpdateUserArea>(
    () => _i250.UpdateUserArea(gh<_i1015.AuthRepository>()));
```

This tells GetIt how to construct UpdateUserArea when needed:
- Create it as a lazy singleton (one instance per app lifecycle)
- Pass AuthRepository as a dependency
- Register it in the service locator

## Testing
The app should now:
1. ✅ Load the area selection dialog
2. ✅ Allow users to select an area
3. ✅ Successfully update the user's selectedAreaId
4. ✅ Proceed to the main app

## Prevention for Future
When adding new usecases or services:
1. Add `@lazySingleton` or `@injectable` annotation
2. Run `flutter pub run build_runner build` to regenerate
3. Verify the generated config includes your new class

## Related Documentation
- See `ADD_AREA_GUIDE.md` for how to add areas
- See `TROUBLESHOOTING_AREA_ERROR.md` for area loading issues
- See `FIX_SERVER_ERROR_DIALOG.md` for timestamp parsing fix
