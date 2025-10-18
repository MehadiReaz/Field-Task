# Quick Start: Integrating Area Management

## 🚀 Add Navigation to Areas Page

### Option 1: Add to Main App Navigation

If you have a drawer or bottom navigation, add this item:

```dart
ListTile(
  leading: const Icon(Icons.location_city),
  title: const Text('Area Management'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => getIt<AreaBloc>(),
          child: const AreasListPage(),
        ),
      ),
    );
  },
),
```

### Option 2: Add as Route (using go_router)

In your router configuration:

```dart
GoRoute(
  path: '/areas',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<AreaBloc>(),
    child: const AreasListPage(),
  ),
),
GoRoute(
  path: '/areas/create',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<AreaBloc>(),
    child: const CreateAreaPage(),
  ),
),
GoRoute(
  path: '/areas/edit/:id',
  builder: (context, state) {
    final area = state.extra as Area;
    return BlocProvider(
      create: (context) => getIt<AreaBloc>(),
      child: CreateAreaPage(area: area),
    );
  },
),
```

## 📱 Usage in Your App

### 1. Provide BLoC at App Level (Recommended)

In your `main.dart` or root widget:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => getIt<AuthBloc>()),
    BlocProvider(create: (_) => getIt<LocationBloc>()),
    BlocProvider(create: (_) => getIt<AreaBloc>()), // Add this
    // ... other providers
  ],
  child: MyApp(),
)
```

### 2. Check if Location is in Any Area

```dart
import 'package:task_trackr/features/areas/domain/usecases/check_location_in_area.dart';

// In your widget
final areaBloc = context.read<AreaBloc>();

// Check specific area
areaBloc.add(CheckLocationInAreaEvent(
  areaId: 'area-123',
  latitude: currentLat,
  longitude: currentLng,
));

// Listen for result
BlocConsumer<AreaBloc, AreaState>(
  listener: (context, state) {
    if (state is LocationInAreaChecked) {
      if (state.isInArea) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Welcome!'),
            content: const Text('You are in the designated area.'),
          ),
        );
      }
    }
  },
  builder: (context, state) => YourWidget(),
)
```

### 3. Filter Tasks by Area

You can extend task functionality to filter by area:

```dart
// Get all areas first
context.read<AreaBloc>().add(const LoadAreasEvent());

// Listen and filter
BlocListener<AreaBloc, AreaState>(
  listener: (context, state) {
    if (state is AreasLoaded) {
      final areasInDhaka = state.areas.where((area) {
        return area.name.toLowerCase().contains('dhaka');
      }).toList();
      
      // Use these areas to filter tasks
    }
  },
)
```

## 🎨 Customize the UI

### Change Map Tiles

In `create_area_page.dart`, replace:

```dart
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.example.task_trackr',
),
```

With alternative providers:
- **Google-style**: `https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}` (requires setup)
- **Satellite**: `https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}`
- **Dark mode**: `https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png`

### Customize Area Card Colors

In `areas_list_page.dart`, modify `_AreaCard`:

```dart
Card(
  margin: const EdgeInsets.only(bottom: 12),
  color: area.isActive ? Colors.white : Colors.grey[200], // Add color
  elevation: 4, // Add shadow
  child: InkWell(
    // ... rest of code
  ),
)
```

## 🔔 Add Geofencing (Advanced)

To trigger notifications when entering/leaving areas:

1. Add `flutter_geofence` or `geofence_service` package
2. Register areas as geofences:

```dart
// Pseudo-code
for (var area in areas) {
  geofenceService.addGeofence(
    Geofence(
      id: area.id,
      latitude: area.centerLatitude,
      longitude: area.centerLongitude,
      radius: area.radiusInMeters,
    ),
  );
}

// Listen for enter/exit events
geofenceService.onGeofenceStatusChanged.listen((geofence) {
  if (geofence.status == GeofenceStatus.ENTER) {
    showNotification('Entered ${geofence.id}');
  } else if (geofence.status == GeofenceStatus.EXIT) {
    showNotification('Left ${geofence.id}');
  }
});
```

## 📊 Add to Dashboard

Show area stats on your dashboard:

```dart
BlocBuilder<AreaBloc, AreaState>(
  builder: (context, state) {
    if (state is AreasLoaded) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.location_city),
          title: const Text('Active Areas'),
          trailing: Text(
            '${state.areas.length}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          onTap: () {
            // Navigate to areas list
          },
        ),
      );
    }
    return const SizedBox();
  },
)
```

## 🔧 Permissions Required

Ensure these permissions are in your app:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to manage areas</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs your location to track areas</string>
```

## 🧪 Test Data

Create sample areas for testing:

```dart
final testAreas = [
  Area(
    id: '1',
    name: 'Gulshan Area',
    centerLatitude: 23.7808,
    centerLongitude: 90.4145,
    radiusInMeters: 1000,
    description: 'Diplomatic zone',
    assignedAgentIds: [],
    createdById: 'test-user',
    createdByName: 'Test User',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Area(
    id: '2',
    name: 'Banani Zone',
    centerLatitude: 23.7937,
    centerLongitude: 90.4066,
    radiusInMeters: 800,
    description: 'Commercial area',
    assignedAgentIds: [],
    createdById: 'test-user',
    createdByName: 'Test User',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
```

## 📈 Monitor Usage

Add analytics tracking:

```dart
// When area is created
context.read<AreaBloc>().add(CreateAreaEvent(area));

// In BLoC listener
if (state is AreaCreated) {
  // Log to analytics
  FirebaseAnalytics.instance.logEvent(
    name: 'area_created',
    parameters: {
      'area_id': state.area.id,
      'area_name': state.area.name,
      'radius': state.area.radiusInMeters,
    },
  );
}
```

## 🐛 Troubleshooting

### Map not loading?
- Check internet connection
- Verify OpenStreetMap tiles URL
- Add internet permission

### Location not detected?
- Request location permissions
- Check if GPS is enabled
- Test on physical device (not emulator)

### Areas not saving to Firestore?
- Check Firestore rules are deployed
- Verify user has admin/manager role
- Check Firebase console for errors

---

**Ready to Use!** 🎉

The area management feature is fully integrated. Just add navigation to `AreasListPage` and you're good to go!
