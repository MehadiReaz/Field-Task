import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class FieldTaskApp extends StatelessWidget {
  const FieldTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = getIt<NotificationService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<LocationBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<SyncBloc>()..add(const StartAutoSyncEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Task Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        scaffoldMessengerKey: notificationService.scaffoldKey,
        builder: (context, child) {
          return ConnectivityBanner(
            connectivityService: getIt<ConnectivityService>(),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
