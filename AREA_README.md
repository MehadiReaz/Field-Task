# 🗺️ Area Management Feature

## Overview
A complete area/zone management system allowing users to create geographic zones with:
- **Name**: e.g., "Banani Zone"
- **Center Point**: Latitude & Longitude
- **Radius**: In meters (up to 10km)
- **Description**: Optional details
- **Agents**: Assignable to specific agents

## 🎯 Quick Start

### 1. Add to Your App Navigation

```dart
import 'package:task_trackr/app/widgets/area_management_navigation.dart';

// Option A: Button
AreaManagementButton()

// Option B: Drawer Item
AreaManagementDrawerItem()

// Option C: Dashboard Card
AreaManagementCard()
```

### 2. Deploy Firestore Rules

```bash
firebase deploy --only firestore:rules
```

### 3. Test!
- Login as admin/manager
- Navigate to Areas page
- Create an area using the interactive map

## 📁 Project Structure

```
lib/features/areas/
├── domain/
│   ├── entities/area.dart
│   ├── repositories/area_repository.dart
│   └── usecases/
│       ├── create_area.dart
│       ├── get_areas.dart
│       ├── get_area_by_id.dart
│       ├── update_area.dart
│       ├── delete_area.dart
│       └── check_location_in_area.dart
├── data/
│   ├── models/area_model.dart
│   ├── datasources/area_remote_data_source.dart
│   └── repositories/area_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── area_bloc.dart
    │   ├── area_event.dart
    │   └── area_state.dart
    └── pages/
        ├── areas_list_page.dart
        └── create_area_page.dart
```

## 🎨 UI Components

### Areas List Page
- View all active areas
- Edit existing areas
- Delete areas (soft delete)
- Refresh functionality
- Empty state message

### Create/Edit Area Page
- **Interactive Map**: OpenStreetMap with tap-to-select
- **Visual Radius**: Circle overlay showing area coverage
- **Form Fields**: Name, description, radius
- **Real-time Address**: Reverse geocoding
- **Current Location**: Quick access button
- **Validation**: Required fields, max radius

## 🔧 API Usage

### Create Area
```dart
final area = Area(
  id: Uuid().v4(),
  name: 'Banani Zone',
  centerLatitude: 23.7937,
  centerLongitude: 90.4066,
  radiusInMeters: 500.0,
  description: 'Commercial district',
  assignedAgentIds: [],
  createdById: currentUser.id,
  createdByName: currentUser.displayName,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isActive: true,
);

context.read<AreaBloc>().add(CreateAreaEvent(area));
```

### Check Location in Area
```dart
context.read<AreaBloc>().add(
  CheckLocationInAreaEvent(
    areaId: 'area-id',
    latitude: 23.7937,
    longitude: 90.4066,
  ),
);

// Listen for result
BlocListener<AreaBloc, AreaState>(
  listener: (context, state) {
    if (state is LocationInAreaChecked) {
      print('In area: ${state.isInArea}');
    }
  },
);
```

### Get All Areas
```dart
context.read<AreaBloc>().add(const LoadAreasEvent());

BlocBuilder<AreaBloc, AreaState>(
  builder: (context, state) {
    if (state is AreasLoaded) {
      return ListView.builder(
        itemCount: state.areas.length,
        itemBuilder: (context, index) {
          final area = state.areas[index];
          return ListTile(
            title: Text(area.name),
            subtitle: Text('${area.radiusInMeters}m radius'),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

## 🔐 Permissions

### Firestore Rules
```javascript
match /areas/{areaId} {
  allow read: if isAuthenticated();
  allow create: if isManager();
  allow update: if isManager();
  allow delete: if isAdmin();
}
```

### Required Roles
- **View**: All authenticated users
- **Create/Edit**: Managers and Admins
- **Delete**: Admins only

## 📊 Data Model

```dart
class Area {
  final String id;
  final String name;
  final double centerLatitude;
  final double centerLongitude;
  final double radiusInMeters;
  final String? description;
  final List<String> assignedAgentIds;
  final String createdById;
  final String createdByName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
}
```

### Firestore Document
```json
{
  "id": "uuid",
  "name": "Banani Zone",
  "centerLatitude": 23.7937,
  "centerLongitude": 90.4066,
  "radiusInMeters": 500.0,
  "description": "Commercial area",
  "assignedAgentIds": [],
  "createdById": "user-id",
  "createdByName": "John Doe",
  "createdAt": "2025-10-18T10:30:00.000Z",
  "updatedAt": "2025-10-18T10:30:00.000Z",
  "isActive": true
}
```

## 📚 Documentation

- **[AREA_FEATURE_SUMMARY.md](./AREA_FEATURE_SUMMARY.md)** - Complete technical documentation
- **[AREA_INTEGRATION_GUIDE.md](./AREA_INTEGRATION_GUIDE.md)** - Integration & customization guide
- **[create_area_flow_IMPLEMENTED.md](./create_area_flow_IMPLEMENTED.md)** - Implementation checklist

## 🚀 Features

✅ CRUD operations (Create, Read, Update, Delete)  
✅ Interactive map with OpenStreetMap  
✅ Visual radius circle overlay  
✅ Real-time location selection  
✅ Address reverse geocoding  
✅ Form validation  
✅ Distance calculations (Haversine)  
✅ Soft delete (isActive flag)  
✅ Firestore integration  
✅ Clean Architecture  
✅ BLoC state management  
✅ Dependency injection  
✅ Zero compilation errors  

## 🎯 Next Steps (Optional)

1. **Agent Assignment UI**: Add multi-select for agents
2. **Area Search**: Implement search/filter
3. **Map Clustering**: Show all areas on one map
4. **Task-Area Link**: Auto-assign tasks to areas
5. **Geofencing**: Notifications on enter/exit
6. **Analytics**: Track area usage stats
7. **Offline Support**: Cache with Drift database

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Map not loading | Check internet, verify tile URL |
| Location not detected | Grant permissions, enable GPS |
| Areas not saving | Deploy Firestore rules, check role |
| Build errors | Run `flutter pub run build_runner build` |

## 📝 Notes

- Areas use **soft delete** (isActive flag)
- Radius limited to **10km maximum**
- Uses **OpenStreetMap** (free, no API key)
- Distance calculations in **meters**
- Coordinates stored with **full precision**

---

**Status**: ✅ Production Ready  
**Version**: 1.0.0  
**Last Updated**: October 18, 2025
