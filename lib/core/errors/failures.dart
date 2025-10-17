import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Auth Failures
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class GoogleSignInFailure extends AuthFailure {
  const GoogleSignInFailure() : super('Google sign-in failed');
}

class EmailSignInFailure extends AuthFailure {
  const EmailSignInFailure() : super('Email sign-in failed');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('User not found');
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Invalid email or password');
}

// Task Failures
class TaskFailure extends Failure {
  const TaskFailure(super.message);
}

class TaskNotFoundFailure extends TaskFailure {
  const TaskNotFoundFailure() : super('Task not found');
}

class TaskCreateFailure extends TaskFailure {
  const TaskCreateFailure() : super('Failed to create task');
}

class TaskUpdateFailure extends TaskFailure {
  const TaskUpdateFailure() : super('Failed to update task');
}

class TaskDeleteFailure extends TaskFailure {
  const TaskDeleteFailure() : super('Failed to delete task');
}

// Location Failures
class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

class LocationPermissionDeniedFailure extends LocationFailure {
  const LocationPermissionDeniedFailure()
      : super('Location permission denied');
}

class LocationServiceDisabledFailure extends LocationFailure {
  const LocationServiceDisabledFailure()
      : super('Location services are disabled');
}

class OutOfRangeFailure extends LocationFailure {
  const OutOfRangeFailure()
      : super('You must be within 100m to perform this action');
}

// Sync Failures
class SyncFailure extends Failure {
  const SyncFailure(super.message);
}

class NetworkFailure extends SyncFailure {
  const NetworkFailure() : super('No internet connection');
}

class ServerFailure extends SyncFailure {
  const ServerFailure() : super('Server error occurred');
}

// Cache Failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Validation Failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}