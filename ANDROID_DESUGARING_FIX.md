# Android Core Library Desugaring Fix

## Problem
When building the Android app (especially `flutter_local_notifications`), the build fails with:

```
A failure occurred while executing com.android.build.gradle.internal.tasks.CheckAarMetadataWorkAction
   > An issue was found when checking AAR metadata:

       1.  Dependency ':flutter_local_notifications' requires core library desugaring to be enabled
           for :app.
```

## Root Cause
The `flutter_local_notifications` package uses Java 8+ features (like `java.time.*` classes and lambda expressions) that aren't available on older Android API levels by default. Core library desugaring automatically converts these modern Java features to work on older APIs (API level 26 and below).

## Solution
Enable core library desugaring in `android/app/build.gradle`:

### 1. Enable Desugaring in compileOptions
```groovy
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
    coreLibraryDesugaringEnabled = true  // Add this line
}
```

### 2. Add Desugaring Dependency
```groovy
dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.3'
}
```

### 3. Enable MultiDex Support (Optional but Recommended)
```groovy
defaultConfig {
    // ... other config ...
    multiDexEnabled = true
}
```

## Changes Made

**File**: `android/app/build.gradle`

### Before:
```groovy
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}
```

### After:
```groovy
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
    coreLibraryDesugaringEnabled = true
}

// ... buildTypes ...

dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.3'
}
```

## Testing the Fix

1. Clean the build:
   ```bash
   flutter clean
   ```

2. Rebuild the APK:
   ```bash
   flutter build apk --release
   ```

3. Or for debug build:
   ```bash
   flutter run
   ```

## Technical Details

### What is Core Library Desugaring?
Core library desugaring is an Android Gradle plugin tool that:
- Converts Java 8+ APIs to work on older API levels
- Uses the `desugar_jdk_libs` library to provide backports
- Allows modern Dart/Flutter packages to work on wider device ranges

### Minimum Configuration
- **Min SDK**: 28 (configured in `defaultConfig`)
- **Target SDK**: 36 (configured in `defaultConfig`)
- **Desugar Library**: `com.android.tools:desugar_jdk_libs:2.0.3`

### Affected Packages
Packages requiring this fix:
- `flutter_local_notifications` (uses `java.time` APIs)
- Any package using Java 8+ features

## Troubleshooting

### Issue: Build still fails
- **Solution**: Run `flutter clean` and rebuild
- **Reason**: Gradle caches old configurations

### Issue: Method count too high
- **Solution**: `multiDexEnabled = true` in `defaultConfig`
- **Reason**: Desugaring adds methods; MultiDex handles large method counts

### Issue: Runtime errors with time APIs
- **Solution**: Ensure `coreLibraryDesugaringEnabled = true` is set
- **Reason**: Desugaring must be enabled for the runtime to work

## References
- [Android Java 8+ Support](https://developer.android.com/studio/write/java8-support.html)
- [Core Library Desugaring Documentation](https://developer.android.com/studio/write/java8-support#library_desugaring)
- [flutter_local_notifications Setup](https://pub.dev/packages/flutter_local_notifications)

## Summary
✅ Core library desugaring enabled for Java 8+ features
✅ MultiDex support added for method count
✅ Desugar library dependency added
✅ Ready to build release APK

Build Status: In Progress 🔨
