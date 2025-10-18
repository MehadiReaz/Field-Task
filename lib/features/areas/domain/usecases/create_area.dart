import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/area.dart';
import '../repositories/area_repository.dart';

@injectable
class CreateArea implements UseCase<Area, CreateAreaParams> {
  final AreaRepository repository;

  CreateArea(this.repository);

  @override
  Future<Either<Failure, Area>> call(CreateAreaParams params) async {
    return await repository.createArea(params.area);
  }
}

class CreateAreaParams {
  final Area area;

  CreateAreaParams({required this.area});
}
