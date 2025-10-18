import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../areas/presentation/bloc/area_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/area_selection_dialog.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Check auth status when splash screen loads
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthAuthenticatedState) {
          // User is authenticated
          print(
              '🔍 Splash: User authenticated. SelectedAreaId: ${state.user.selectedAreaId}');

          // Check if user has selected an area
          if (state.user.selectedAreaId == null) {
            print('⚠️ Splash: No area selected, showing dialog');

            // Wait a bit to ensure the widget tree is built
            await Future.delayed(const Duration(milliseconds: 300));

            if (!mounted) return;

            // Show area selection dialog
            print('📱 Splash: Showing area selection dialog');
            final result = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => BlocProvider(
                create: (context) => getIt<AreaBloc>(),
                child: const AreaSelectionDialog(isRequired: true),
              ),
            );

            print('✅ Splash: Dialog result: $result');

            if (result == true && mounted) {
              // Area selected, proceed to home
              print('✅ Splash: Area selected, navigating to home');
              context.go(RouteNames.home);
            } else if (mounted) {
              // If dialog was somehow dismissed without selection, show error
              print('❌ Splash: Dialog dismissed without selection');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You must select an area to continue'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            // User has area selected, navigate to home
            print('✅ Splash: User has area, navigating to home');
            context.go(RouteNames.home);
          }
        } else if (state is AuthUnauthenticatedState) {
          // User is not authenticated, navigate to login
          print('🔒 Splash: User not authenticated, navigating to login');
          context.go(RouteNames.login);
        }
        // If Loading or Initial, stay on splash screen
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              // App Name
              const Text(
                'TaskTrackr',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Field Task Management',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 48),
              // Loading Indicator
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Checking authentication...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
