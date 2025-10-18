import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/area.dart';
import '../repositories/area_repository.dart';

@injectable
class UpdateArea implements UseCase<Area, UpdateAreaParams> {
  final AreaRepository repository;

  UpdateArea(this.repository);

  @override
  Future<Either<Failure, Area>> call(UpdateAreaParams params) async {
    return await repository.updateArea(params.area);
  }
}

class UpdateAreaParams {
  final Area area;

  UpdateAreaParams({required this.area});
}
