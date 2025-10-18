import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await remoteDataSource.signInWithGoogle();
      await localDataSource.cacheUser(user);
      // Save auth token (user ID as token)
      await localDataSource.saveAuthToken(user.id);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail(
    String email,
    String password,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await remoteDataSource.signInWithEmail(email, password);
      await localDataSource.cacheUser(user);
      // Save auth token (user ID as token)
      await localDataSource.saveAuthToken(user.id);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearCache();
      await localDataSource.clearAuthToken();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      // If not in cache and online, get from remote
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(user);
        return Right(user);
      }

      return const Left(AuthFailure('No cached user found'));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final token = await localDataSource.getAuthToken();
      final cachedUser = await localDataSource.getCachedUser();
      return Right(token != null && cachedUser != null);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, User>> updateUserArea(
      String userId, String areaId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await remoteDataSource.updateUserArea(userId, areaId);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }
}
