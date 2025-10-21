# Field Task 📱

A location-based field task management application for on-field agents with robust offline support and real-time syncing capabilities.

---

## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [App Flow](#app-flow)
- [Offline & Syncing Approach](#offline--syncing-approach)
- [Architecture & Design Decisions](#architecture--design-decisions)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)

---

## 🎯 Overview

Field Task is a mobile application designed for field agents who need to manage and complete location-based tasks throughout their workday. The app ensures agents can work seamlessly even in areas with poor or no connectivity, with automatic synchronization when back online.

**Key Highlights:**
- ✅ Location-verified task check-ins (within 100 meters)
- ✅ Complete offline functionality with local database
- ✅ Automatic background sync with retry logic
- ✅ Real-time sync status indicators and notifications
- ✅ Expired task tracking and notifications
- ✅ Clean architecture with BLoC state management

---

## ✨ Features

### 1. **Authentication**
- Google Sign-In integration
- Email/Password authentication
- Secure token storage with Flutter Secure Storage
- Persistent login state with auto-login

### 2. **Task Management**
- View all assigned tasks in a paginated list
- Create new tasks with title, description, due date/time
- Interactive map for selecting task location
- Task details with map preview
- Search tasks by title or description
- Filter tasks by status (All, Pending, Completed, Expired)
- Sort tasks by date, priority, or status

### 3. **Location-Based Operations**
- GPS-verified check-in (proximity validation: 100m radius)
- Real-time distance calculation to task location
- Visual distance indicators on task cards
- Interactive map with current location and task markers
- Location permission handling

### 4. **Task Completion**
- Only the assigned agent can complete tasks
- Location proximity required for completion
- Automatic status updates
- Completion timestamp tracking

### 5. **Offline Support**
- Full CRUD operations work offline
- Local SQLite database using Drift ORM
- Automatic sync queue for pending operations
- View cached tasks and history offline
- Offline mode notifications

### 6. **Sync System**
- Automatic background sync every 5 minutes
- Network change detection with auto-sync
- Manual sync trigger option
- Visual sync status indicators on UI
- Retry logic (max 3 attempts per operation)
- Pending operation badges on tasks and menu
- Real-time sync progress notifications

### 7. **History & Statistics**
- View completed and expired tasks
- Task completion timeline
- Filter and sort historical data
- Works completely offline

### 8. **Notifications**
- Expired task notifications (checks every 30 minutes)
- In-app snackbar notifications for all operations
- Color-coded notifications (success, error, warning, info)
- Haptic feedback for important actions

### 9. **Dashboard**
- Task statistics and insights
- Quick overview of pending, completed, and expired tasks
- Visual charts and progress indicators

---

## 🔄 App Flow

### 1. **Authentication Flow**
```
Splash Screen → Check Auth Status
├─ Authenticated → Home (Task List)
└─ Not Authenticated → Login Page
   ├─ Google Sign-In
   └─ Email/Password Sign-In
```

### 2. **Task Management Flow**
```
Home (Task List)
├─ View Tasks (Paginated, Searchable, Filterable)
├─ Create New Task
│  └─ Fill Form → Select Location on Map → Save
├─ Task Details
│  ├─ View on Map
│  ├─ Check-In (if within 100m)
│  └─ Complete Task (if checked in)
└─ Filter/Search Tasks
```

### 3. **Offline Operation Flow**
```
User Action (Create/Update/Delete)
├─ Online: Direct Firestore Operation → Update Local Cache
└─ Offline: Save to Local DB → Add to Sync Queue
    └─ Network Reconnects → Auto-Sync Queue → Update Firestore
```

---

## 📡 Offline & Syncing Approach

### **Offline-First Architecture**

The app follows an **offline-first approach**, ensuring all operations work seamlessly without network connectivity.

#### **1. Local Database (Drift/SQLite)**
- **Tasks Table**: Stores all task data locally
- **Users Table**: Caches user information
- **Sync Queue Table**: Tracks pending operations

```dart
// Example: Tasks are always available offline
final tasks = await localDataSource.getTasks();
```

#### **2. Dual Data Source Pattern**
Every repository implements two data sources:
- **Remote Data Source**: Firebase Firestore operations
- **Local Data Source**: SQLite (Drift) operations

```dart
// Repository decision logic
Future<List<Task>> getTasks() async {
  if (await networkInfo.isConnected) {
    // Fetch from Firestore and cache locally
    final tasks = await remoteDataSource.getTasks();
    await localDataSource.cacheTasks(tasks);
    return tasks;
  } else {
    // Return cached data
    return await localDataSource.getTasks();
  }
}
```

#### **3. Sync Queue System**

When offline, all mutations (create, update, delete) are:
1. Applied to local database immediately
2. Added to sync queue with operation type
3. User sees instant feedback with "Pending" badge

```dart
// Offline create example
if (!isConnected) {
  await localDataSource.createTask(task);
  await syncQueue.add(
    operation: 'CREATE',
    entityType: 'TASK',
    entityId: task.id,
    data: task.toJson(),
  );
  notificationService.showOfflineMode('Task created');
}
```

#### **4. Automatic Sync Triggers**

The sync service monitors:
- **Network Changes**: Connectivity Plus detects when device goes online
- **Periodic Checks**: Background sync every 5 minutes
- **App Lifecycle**: Sync on app resume
- **Manual Trigger**: User can force sync anytime

```dart
// Auto-sync on network reconnection
connectivityStream.listen((status) {
  if (status == ConnectivityResult.mobile || 
      status == ConnectivityResult.wifi) {
    syncService.processSyncQueue();
  }
});
```

#### **5. Sync Conflict Resolution**

- **Last-Write-Wins**: Most recent timestamp takes precedence
- **Retry Logic**: Failed syncs retry up to 3 times with exponential backoff
- **Error Handling**: Users notified of sync failures with manual retry option

#### **6. Visual Sync Feedback**

Users always know sync status through:
- **Sync Status Indicator**: Large banner at top of task list showing "Syncing", "Synced", "Failed", or "Pending"
- **Task Badges**: Orange "Pending" or red "Failed" badges on individual task cards
- **Menu Badge**: Red circle with pending count on Menu tab
- **Notifications**: Snackbars for all sync events (success, failure, progress)

```
┌─────────────────────────────────────┐
│ 🔵 Syncing... (3 items)            │ ← Status Banner
└─────────────────────────────────────┘

Task Card:  [Pending] 🟠 ← Badge showing unsync'd task
```

---

## 🏗️ Architecture & Design Decisions

### **1. Clean Architecture**

The project follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (BLoC, Pages, Widgets)                 │
├─────────────────────────────────────────┤
│           Domain Layer                  │
│  (Entities, Use Cases, Repositories)    │
├─────────────────────────────────────────┤
│            Data Layer                   │
│  (Models, Data Sources, Repo Impl)      │
└─────────────────────────────────────────┘
```

**Benefits:**
- ✅ Testability: Each layer can be tested independently
- ✅ Maintainability: Changes in one layer don't affect others
- ✅ Scalability: Easy to add new features
- ✅ Flexibility: Can swap implementations (e.g., change database)

### **2. Feature-Based Structure**

Each feature is self-contained with its own layers:

```
features/
├── auth/
│   ├── data/
│   ├── domain/
│   └── presentation/
├── tasks/
│   ├── data/
│   ├── domain/
│   └── presentation/
└── sync/
    ├── data/
    ├── domain/
    └── presentation/
```

### **3. State Management: BLoC Pattern**

**Why BLoC?**
- ✅ **Unidirectional Data Flow**: Predictable state transitions
- ✅ **Separation**: Business logic separate from UI
- ✅ **Testability**: Easy to test with bloc_test
- ✅ **Streams**: Perfect for async operations and real-time updates

```dart
// Example: Task List BLoC
TaskListBloc
├── Events: LoadTasks, CreateTask, UpdateTask, DeleteTask
├── States: Loading, Loaded, Error
└── Handles: Network checks, local/remote switching, error handling
```

### **4. Dependency Injection: GetIt + Injectable**

**Why GetIt?**
- ✅ Service Locator pattern for dependency management
- ✅ Lazy/Singleton registration
- ✅ Easy testing with mock injection
- ✅ Code generation with @injectable annotations

```dart
@injectable
class TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  TaskRepository(
    this.remoteDataSource,
    this.localDataSource,
    this.networkInfo,
  );
}
```

### **5. Database: Drift (SQLite)**

**Why Drift?**
- ✅ Type-safe SQL queries with compile-time checking
- ✅ Reactive streams for real-time updates
- ✅ Automatic migrations
- ✅ Code generation for boilerplate reduction
- ✅ Cross-platform support

```dart
@DriftDatabase(tables: [Tasks, Users, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
}
```

### **6. Backend: Firebase**

**Why Firebase?**
- ✅ **Firestore**: NoSQL real-time database with offline support
- ✅ **Authentication**: Built-in auth with Google, Email/Password
- ✅ **Scalability**: Handles millions of users
- ✅ **Security**: Fine-grained security rules
- ✅ **Cost-Effective**: Free tier sufficient for MVP

### **7. Maps: flutter_map (OpenStreetMap)**

**Why flutter_map?**
- ✅ Free and open-source (no API keys needed)
- ✅ Highly customizable
- ✅ Lightweight
- ✅ Good offline support with cached tiles

### **8. Error Handling: Dartz (Either Type)**

```dart
// Functional error handling
Future<Either<Failure, Task>> getTask(String id) async {
  try {
    final task = await dataSource.getTask(id);
    return Right(task);
  } catch (e) {
    return Left(CacheFailure());
  }
}
```

**Benefits:**
- ✅ Explicit error handling
- ✅ No exceptions thrown
- ✅ Type-safe success/failure

### **9. Navigation: go_router**

**Why go_router?**
- ✅ Declarative routing
- ✅ Deep linking support
- ✅ Type-safe navigation
- ✅ Guards for authentication

---

## 🛠️ Tech Stack

### **Frontend**
- **Flutter 3.6+**: Cross-platform UI framework
- **Dart 3.6+**: Programming language

### **State Management**
- **flutter_bloc 8.1.3**: BLoC pattern implementation
- **equatable 2.0.5**: Value equality for state comparison

### **Dependency Injection**
- **get_it 7.6.4**: Service locator
- **injectable 2.3.2**: Code generation for DI

### **Backend Services**
- **Firebase Core 4.2.0**: Firebase SDK
- **Firebase Auth 6.1.1**: Authentication
- **Cloud Firestore 6.0.3**: NoSQL database
- **google_sign_in 7.2.0**: Google OAuth

### **Local Database**
- **drift 2.14.1**: Type-safe SQLite wrapper
- **sqlite3_flutter_libs 0.5.18**: SQLite binaries
- **path_provider 2.1.1**: Local storage paths

### **Location & Maps**
- **geolocator 10.1.0**: GPS location access
- **flutter_map 8.2.2**: OpenStreetMap integration
- **geocoding 2.1.1**: Address/coordinate conversion

### **Network & Storage**
- **connectivity_plus 5.0.2**: Network status monitoring
- **shared_preferences 2.2.2**: Key-value storage
- **flutter_secure_storage 9.0.0**: Encrypted storage

### **UI/UX**
- **cached_network_image 3.3.0**: Image caching
- **flutter_spinkit 5.2.0**: Loading indicators
- **shimmer 3.0.0**: Skeleton loading
- **lottie 2.7.0**: Animations
- **fluttertoast 8.2.4**: Toast messages

### **Utilities**
- **intl 0.18.1**: Internationalization & date formatting
- **uuid 4.2.2**: Unique ID generation
- **dartz 0.10.1**: Functional programming (Either)
- **rxdart 0.27.7**: Reactive extensions
- **logger 2.0.2**: Logging utility

### **Notifications**
- **flutter_local_notifications 18.0.1**: Local push notifications
- **vibration 3.1.4**: Haptic feedback

### **Development Tools**
- **build_runner 2.4.7**: Code generation
- **drift_dev 2.14.1**: Drift code generation
- **injectable_generator 2.4.1**: DI code generation
- **mocktail 1.0.1**: Mocking for tests
- **bloc_test 9.1.5**: BLoC testing utilities
- **flutter_lints 3.0.1**: Linting rules

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.6.0 or higher
- Android Studio / Xcode (for iOS)
- Firebase account (already configured)

### **Installation**

1. **Clone the repository**
```bash
git clone https://github.com/MehadiReaz/task-trackr.git
cd task-trackr
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code** (for Drift, Injectable, etc.)
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

### **Build APK**
```bash
# Debug APK
flutter build apk

# Release APK (for production)
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── injection_container.dart           # Dependency injection setup
│
├── app/                               # App-level configuration
│   ├── app.dart                       # MaterialApp setup
│   ├── routes/                        # Navigation (go_router)
│   └── theme/                         # App theme & styling
│
├── core/                              # Shared utilities
│   ├── constants/                     # App constants
│   ├── enums/                         # Enumerations (TaskStatus, etc.)
│   ├── errors/                        # Failure & exception classes
│   ├── network/                       # Network connectivity checker
│   ├── services/                      # Global services
│   │   ├── notification_service.dart  # In-app notifications
│   │   ├── local_notification_service.dart  # Push notifications
│   │   └── expired_tasks_checker_service.dart  # Background checker
│   └── utils/                         # Utility functions
│
├── database/                          # Drift database
│   ├── database.dart                  # Database definition
│   ├── tables/                        # Table definitions
│   └── daos/                          # Data access objects
│
└── features/                          # Feature modules
    │
    ├── auth/                          # Authentication
    │   ├── data/                      # Data layer
    │   │   ├── datasources/           # Remote/Local data sources
    │   │   ├── models/                # Data models
    │   │   └── repositories/          # Repository implementations
    │   ├── domain/                    # Domain layer
    │   │   ├── entities/              # Business entities
    │   │   ├── repositories/          # Repository interfaces
    │   │   └── usecases/              # Use cases
    │   └── presentation/              # Presentation layer
    │       ├── bloc/                  # BLoC state management
    │       ├── pages/                 # UI pages
    │       └── widgets/               # Reusable widgets
    │
    ├── tasks/                         # Task management
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    ├── location/                      # Location services
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    ├── sync/                          # Sync system
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    ├── dashboard/                     # Dashboard & statistics
    │   └── presentation/
    │
    └── home/                          # Home navigation
        └── presentation/
```

---

## 🎨 Design Patterns Used

1. **Repository Pattern**: Abstracts data sources
2. **BLoC Pattern**: Unidirectional data flow for state management
3. **Dependency Injection**: Loose coupling with GetIt
4. **Factory Pattern**: For creating instances
5. **Observer Pattern**: For reactive programming with streams
6. **Singleton Pattern**: For services (NotificationService, SyncService)

---

## 🧪 Testing

The project includes unit tests and widget tests:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

---

## 📱 APK Download

The release APK is available in the repository at:
```
build/app/outputs/flutter-apk/app-release.apk
```

Or download from the releases section of this repository.

---

## 🔐 Security Considerations

- ✅ Firebase security rules configured for user-specific data access
- ✅ Sensitive tokens stored in Flutter Secure Storage (encrypted)
- ✅ Location permissions requested with proper rationale
- ✅ No hardcoded credentials or API keys in code

---

## 🚦 Known Limitations

1. **Map Tiles**: Requires internet for first-time tile loading (offline caching implemented)
2. **GPS Accuracy**: Indoor locations may have reduced accuracy
3. **Background Sync**: Limited by OS battery optimization on some devices

---

## 📄 License

This project is part of an assessment and is for educational purposes.

---

## 👤 Author

**Mehadi Hasan Reaz**
- GitHub: [@MehadiReaz](https://github.com/MehadiReaz)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- OpenStreetMap for free map tiles
- All open-source contributors whose packages were used

---

**Built with ❤️ using Flutter**
