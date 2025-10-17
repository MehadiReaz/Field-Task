part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final User user;

  const AuthAuthenticatedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}