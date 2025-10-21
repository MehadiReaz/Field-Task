import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/services/dashboard_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithEmail signInWithEmail;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final CheckAuthStatus checkAuthStatus;
  final DashboardService dashboardService;

  AuthBloc({
    required this.signInWithGoogle,
    required this.signInWithEmail,
    required this.signOut,
    required this.getCurrentUser,
    required this.checkAuthStatus,
    required this.dashboardService,
  }) : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignOutEvent>(_onSignOut);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    final result = await checkAuthStatus(const NoParams());

    await result.fold(
      (failure) async {
        emit(AuthUnauthenticatedState());
      },
      (isAuthenticated) async {
        if (isAuthenticated) {
          final userResult = await getCurrentUser(const NoParams());
          userResult.fold(
            (failure) {
              emit(AuthUnauthenticatedState());
            },
            (user) {
              // Initialize dashboard on successful auth
              _initializeDashboard();
              emit(AuthAuthenticatedState(user: user));
            },
          );
        } else {
          emit(AuthUnauthenticatedState());
        }
      },
    );
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    final result = await signInWithGoogle(const NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthAuthenticatedState(user: user)),
    );
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    final result = await signInWithEmail(
      SignInWithEmailParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) {
        // Initialize dashboard on successful login
        _initializeDashboard();
        emit(AuthAuthenticatedState(user: user));
      },
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('SignOut event received');
    emit(AuthLoadingState());

    final result = await signOut(const NoParams());

    result.fold(
      (failure) {
        AppLogger.error('SignOut failed: ${failure.message}');
        emit(AuthErrorState(message: failure.message));
      },
      (_) {
        AppLogger.info(
            'SignOut successful - emitting AuthUnauthenticatedState');
        emit(AuthUnauthenticatedState());
      },
    );
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUser(const NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthAuthenticatedState(user: user)),
    );
  }

  /// Initialize dashboard with counts on login
  void _initializeDashboard() {
    // Run in background without blocking login
    dashboardService.initializeDashboard().then((_) {
      return dashboardService.recalculateAllCounts();
    }).then((_) {
      AppLogger.info('Dashboard initialized and counts recalculated');
    }).catchError((error) {
      AppLogger.error('Failed to initialize dashboard: $error');
    });
  }
}
