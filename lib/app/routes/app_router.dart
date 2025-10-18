import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/tasks/presentation/pages/task_list_page.dart';
import '../../features/tasks/presentation/pages/task_detail_page.dart';
import '../../features/tasks/presentation/pages/task_form_page.dart';
import '../../features/location/presentation/pages/map_selection_page.dart';
import '../../features/location/presentation/pages/full_map_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: GoRouterRefreshStream(
        // Listen to auth state changes
        ),
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isAuthenticated = authState is AuthAuthenticatedState;

      final isOnLoginPage = state.matchedLocation == RouteNames.login;
      final isOnSplashPage = state.matchedLocation == RouteNames.splash;

      // If not authenticated and not on login/splash, redirect to login
      if (!isAuthenticated && !isOnLoginPage && !isOnSplashPage) {
        return RouteNames.login;
      }

      // If authenticated and on login/splash, redirect to home
      if (isAuthenticated && (isOnLoginPage || isOnSplashPage)) {
        return RouteNames.home;
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.taskList,
        builder: (context, state) => const TaskListPage(),
      ),
      GoRoute(
        path: RouteNames.taskDetail,
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailPage(taskId: taskId);
        },
      ),
      GoRoute(
        path: RouteNames.createTask,
        builder: (context, state) => const TaskFormPage(),
      ),
      GoRoute(
        path: RouteNames.editTask,
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskFormPage(taskId: taskId);
        },
      ),
      GoRoute(
        path: RouteNames.mapSelection,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MapSelectionPage(
            initialLat: extra?['lat'] as double?,
            initialLng: extra?['lng'] as double?,
          );
        },
      ),
      GoRoute(
        path: RouteNames.fullMap,
        builder: (context, state) => const FullMapPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

// Helper class to refresh router on auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream();
}
