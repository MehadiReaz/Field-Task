import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/area.dart';
import '../repositories/area_repository.dart';

@injectable
class GetAreaById implements UseCase<Area, GetAreaByIdParams> {
  final AreaRepository repository;

  GetAreaById(this.repository);

  @override
  Future<Either<Failure, Area>> call(GetAreaByIdParams params) async {
    return await repository.getAreaById(params.id);
  }
}

class GetAreaByIdParams {
  final String id;

  GetAreaByIdParams({required this.id});
}
