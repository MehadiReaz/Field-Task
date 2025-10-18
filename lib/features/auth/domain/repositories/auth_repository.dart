import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, bool>> checkAuthStatus();
  Future<Either<Failure, User>> updateUserArea(String userId, String areaId);
  Stream<User?> get authStateChanges;
}
