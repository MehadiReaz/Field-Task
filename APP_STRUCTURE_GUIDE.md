# 📱 Task Trackr - Complete App Structure

## App Flow Diagram

```
┌─────────────────────────────────────────────┐
│           APP STARTS                        │
│         (Splash Screen)                     │
└──────────────┬──────────────────────────────┘
               │
          Check Auth
               │
      ┌────────┴────────┐
      │                 │
   ❌ Not          ✅ Authenticated
 Authenticated          │
      │                 │
┌─────▼─────┐    ┌──────▼──────────────┐
│   LOGIN   │    │    HOME PAGE        │
│   PAGE    │    │  (Bottom Nav)       │
└─────┬─────┘    └──────┬──────────────┘
      │                 │
      │    Sign In      │
      └────────►────────┘
                        │
        ┌───────────────┼──────────────┬──────────────┬────────────┐
        │               │              │              │            │
   ┌────▼────┐    ┌────▼────┐   ┌────▼────┐   ┌────▼────┐  ┌────▼────┐
   │Dashboard│    │  Tasks  │   │   Map   │   │  Areas  │  │ Profile │
   └────┬────┘    └────┬────┘   └────┬────┘   └────┬────┘  └────┬────┘
        │              │              │              │            │
        ▼              ▼              ▼              ▼            ▼
```

## Feature Breakdown

### 🏠 HOME PAGE
```
┌──────────────────────────────────────────────────────┐
│  HOME PAGE (Main Container)                         │
│  ┌────────────────────────────────────────────────┐ │
│  │                                                │ │
│  │  Current Tab Content (PageView)               │ │
│  │                                                │ │
│  │  • Dashboard                                  │ │
│  │  • Tasks List                                 │ │
│  │  • Map View                                   │ │
│  │  • Areas Management                           │ │
│  │  • Profile & Settings                         │ │
│  │                                                │ │
│  └────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────┐ │
│  │  📊    ✅    🗺️    📍    👤                      │ │
│  │ Dash  Task  Map  Area  Prof                   │ │
│  └────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

### 📊 DASHBOARD TAB
```
┌────────────────────────────────────────┐
│  Dashboard                    🔄        │
├────────────────────────────────────────┤
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  Welcome back, John!            │ │
│  │  Friday, October 18, 2025       │ │
│  └──────────────────────────────────┘ │
│                                        │
│  Overview                              │
│  ┌──────────┐  ┌──────────┐          │
│  │ 📋 Total │  │ ⏳ Pend  │          │
│  │   10     │  │    5     │          │
│  └──────────┘  └──────────┘          │
│  ┌──────────┐  ┌──────────┐          │
│  │ ✅ Done  │  │ 🔥 Today │          │
│  │    4     │  │    2     │          │
│  └──────────┘  └──────────┘          │
│                                        │
│  Quick Actions                         │
│  ┌──────────┐  ┌──────────┐          │
│  │  ➕       │  │   🗺️     │          │
│  │ Create   │  │  View    │          │
│  │  Task    │  │   Map    │          │
│  └──────────┘  └──────────┘          │
│  ┌──────────┐  ┌──────────┐          │
│  │  📍      │  │   📍     │          │
│  │ Manage   │  │   My     │          │
│  │  Areas   │  │ Location │          │
│  └──────────┘  └──────────┘          │
│                                        │
│  Recent Tasks         See All >        │
│  ┌──────────────────────────────────┐ │
│  │ ⏳ Task 1                        │ │
│  │    Description...                │ │
│  │    📅 Oct 18, 2:30 PM           │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │ ✅ Task 2                        │ │
│  │    Description...                │ │
│  │    📅 Oct 18, 4:00 PM           │ │
│  └──────────────────────────────────┘ │
│                                        │
└────────────────────────────────────────┘
          ┌───────────────┐
          │  ➕ New Task  │
          └───────────────┘
```

### ✅ TASKS TAB
```
┌────────────────────────────────────────┐
│  My Tasks           🔍 Filter  🔄      │
├────────────────────────────────────────┤
│                                        │
│  🟠 Pending  🔵 Checked  ✅ Done       │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │ ⏳ Install Security System       │ │
│  │    Customer: ABC Corp            │ │
│  │    📍 123 Main St                │ │
│  │    📅 Today, 2:30 PM             │ │
│  │    🎯 High Priority              │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │ ✅ Maintenance Check             │ │
│  │    Customer: XYZ Ltd             │ │
│  │    📍 456 Oak Ave                │ │
│  │    📅 Yesterday                  │ │
│  │    🎯 Normal                     │ │
│  └──────────────────────────────────┘ │
│                                        │
└────────────────────────────────────────┘
          ┌───────────────┐
          │  ➕ New Task  │
          └───────────────┘
```

### 🗺️ MAP TAB
```
┌────────────────────────────────────────┐
│  Task Map                      🔄       │
├────────────────────────────────────────┤
│                                        │
│  ┌──────────────────────────────────┐ │
│  │                                  │ │
│  │        🗺️ MAP VIEW               │ │
│  │                                  │ │
│  │    📍 Task A                     │ │
│  │        📍 Task B                 │ │
│  │            📍 Task C             │ │
│  │                                  │ │
│  │                         🎯       │ │
│  │                    (Current Loc) │ │
│  │                                  │ │
│  └──────────────────────────────────┘ │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  Task: Install Security          │ │
│  │  📍 2.3 km away                  │ │
│  │  [Navigate] [Details]            │ │
│  └──────────────────────────────────┘ │
│                                        │
└────────────────────────────────────────┘
     ┌─────┐
     │  🎯 │  (Center on location)
     └─────┘
```

### 📍 AREAS TAB
```
┌────────────────────────────────────────┐
│  Area Management               🔄       │
├────────────────────────────────────────┤
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  Banani Zone                     │ │
│  │  Commercial district             │ │
│  │  📍 23.79°N, 90.40°E             │ │
│  │  ⭕ 500m radius                  │ │
│  │  👥 5 agents assigned            │ │
│  │                           🗑️      │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │  Gulshan Area                    │ │
│  │  Diplomatic zone                 │ │
│  │  📍 23.78°N, 90.41°E             │ │
│  │  ⭕ 1km radius                   │ │
│  │  👥 3 agents assigned            │ │
│  │                           🗑️      │ │
│  └──────────────────────────────────┘ │
│                                        │
└────────────────────────────────────────┘
       ┌──────────────┐
       │ ➕ Add Area  │
       └──────────────┘
```

### 👤 PROFILE TAB
```
┌────────────────────────────────────────┐
│  Profile                       ⚙️       │
├────────────────────────────────────────┤
│                                        │
│       ┌──────────┐                     │
│       │   👤    │                      │
│       │  Photo  │                      │
│       └──────────┘                     │
│                                        │
│       John Doe                         │
│       john@example.com                 │
│       Agent                            │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  📊 My Statistics                │ │
│  │  • Tasks Completed: 42           │ │
│  │  • Active Tasks: 8               │ │
│  │  • Success Rate: 95%             │ │
│  └──────────────────────────────────┘ │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  🔔 Notifications                │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │  ⚙️  Settings                    │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │  🌙 Dark Mode                    │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │  📱 About                        │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │  🚪 Logout                       │ │
│  └──────────────────────────────────┘ │
│                                        │
└────────────────────────────────────────┘
```

## Navigation Matrix

| From Tab | To Dashboard | To Tasks | To Map | To Areas | To Profile |
|----------|--------------|----------|--------|----------|------------|
| Dashboard | ● | Tap tab | Tap tab | Tap tab | Tap tab |
| Tasks | Tap tab | ● | Tap tab | Tap tab | Tap tab |
| Map | Tap tab | Tap tab | ● | Tap tab | Tap tab |
| Areas | Tap tab | Tap tab | Tap tab | ● | Tap tab |
| Profile | Tap tab | Tap tab | Tap tab | Tap tab | ● |

**● = Current tab**

## Quick Actions Map

```
Dashboard Quick Actions:
├─ Create Task ──────► Opens Task Form Page
├─ View Map ─────────► Switches to Map Tab (index 2)
├─ Manage Areas ─────► Switches to Areas Tab (index 3)
└─ My Location ──────► Triggers location fetch

Recent Tasks:
└─ Tap Task Card ────► Opens Task Detail Page

Stats Cards:
└─ All clickable ────► (Can add filters in future)

FloatingActionButton:
└─ Tap ──────────────► Opens Task Form Page
```

## Data Flow

```
User Login
    ↓
AuthBloc (stores user state)
    ↓
Home Page (provides blocs)
    ↓
    ├─► Dashboard ──► TaskBloc (get stats)
    ├─► Tasks ──────► TaskBloc (get all tasks)
    ├─► Map ────────► TaskBloc + LocationBloc
    ├─► Areas ──────► AreaBloc (get areas)
    └─► Profile ────► AuthBloc (user data)
```

## Key Components

### 1. HomePage (Container)
- Manages PageView
- Provides BottomNavigationBar
- Handles tab switching
- Coordinates between tabs

### 2. DashboardPage
- Welcome section with user greeting
- 4 stat cards (total, pending, completed, due today)
- 4 quick action cards
- Recent tasks list (last 5)
- Pull-to-refresh
- FloatingActionButton

### 3. TaskListPage (existing, now tab)
- Full task list
- Filter and sort
- Task cards with status
- Create/edit/delete

### 4. FullMapPage (existing, now tab)
- Map with task markers
- Current location marker
- Task details on tap
- Navigate to task

### 5. AreasListPage (new feature, now tab)
- List of all areas
- Create/edit/delete areas
- Visual map integration

### 6. ProfilePage (existing, now tab)
- User information
- Statistics
- Settings
- Logout

## Color Coding

| Status/Type | Color | Icon |
|-------------|-------|------|
| Total Tasks | 🔵 Blue | 📋 |
| Pending | 🟠 Orange | ⏳ |
| Completed | 🟢 Green | ✅ |
| Due Today | 🔴 Red | 🔥 |
| Checked In | 🔵 Blue | 📍 |
| Cancelled | ⚫ Gray | ❌ |

## Bottom Nav Icons

```
📊 Dashboard  → dashboard icon
✅ Tasks      → task_alt icon
🗺️ Map        → map icon
📍 Areas      → location_city icon
👤 Profile    → person icon
```

## Interaction Patterns

### Tap Behaviors
- **Bottom Nav Item**: Switch to tab
- **Quick Action Card**: Execute action
- **Stat Card**: (Future: filter view)
- **Task Card**: Open detail page
- **FAB**: Create new task

### Long Press (Future)
- **Task Card**: Show context menu
- **Area Card**: Quick actions

### Swipe (Currently Disabled)
- Can enable horizontal swipe between tabs
- Pull-down: Refresh

### Search (Future Enhancement)
- Global search bar on dashboard
- Filter across all content

---

## 📊 Statistics

- **Total Pages**: 2 new (HomePage, DashboardPage)
- **Total Tabs**: 5 (Dashboard, Tasks, Map, Areas, Profile)
- **Quick Actions**: 4
- **Stat Cards**: 4
- **Recent Items**: Up to 5 tasks
- **Bottom Nav Items**: 5
- **Lines of Code**: ~750 (new files)

## 🎯 Accessibility

- All icons have labels
- Tooltips on navigation items
- Semantic widgets used
- Screen reader compatible
- High contrast support

---

**Your app now has a complete, professional structure with intuitive navigation!** 🎉
