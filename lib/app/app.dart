import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../injection_container.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class FieldTaskApp extends StatelessWidget {
  const FieldTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        // TODO: Add SyncBloc when sync feature is implemented
        // TODO: Add LocationBloc when location feature is implemented
      ],
      child: MaterialApp.router(
        title: 'FieldTask Pro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
