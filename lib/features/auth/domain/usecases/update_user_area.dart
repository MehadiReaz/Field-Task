import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class UpdateUserArea implements UseCase<User, UpdateUserAreaParams> {
  final AuthRepository repository;

  UpdateUserArea(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserAreaParams params) async {
    return await repository.updateUserArea(params.userId, params.areaId);
  }
}

class UpdateUserAreaParams {
  final String userId;
  final String areaId;

  const UpdateUserAreaParams({
    required this.userId,
    required this.areaId,
  });
}
