import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/settings/presentation/notifier/theme_notifier.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/notification_service.dart';
import '../core/widgets/connectivity_banner.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/location/presentation/bloc/location_bloc.dart';
import '../features/sync/presentation/bloc/sync_bloc.dart';
import '../features/sync/presentation/bloc/sync_event.dart';
import '../injection_container.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class TaskTrackrApp extends StatelessWidget {
  const TaskTrackrApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = getIt<NotificationService>();
    final authBloc = getIt<AuthBloc>()..add(CheckAuthStatusEvent());

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: authBloc,
        ),
        BlocProvider(
          create: (_) =>
              getIt<LocationBloc>()..add(const CheckPermissionEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<SyncBloc>()..add(const StartAutoSyncEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<ThemeBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => MaterialApp.router(
          title: 'Field Task',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.mode,
          routerConfig: AppRouter.createRouter(authBloc),
          scaffoldMessengerKey: notificationService.scaffoldKey,
          builder: (context, child) {
            return ConnectivityBanner(
              connectivityService: getIt<ConnectivityService>(),
              child: child ?? const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
