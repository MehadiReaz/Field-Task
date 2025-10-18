import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/area_repository.dart';

@injectable
class CheckLocationInArea implements UseCase<bool, CheckLocationInAreaParams> {
  final AreaRepository repository;

  CheckLocationInArea(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckLocationInAreaParams params) async {
    return await repository.isLocationInArea(
      areaId: params.areaId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class CheckLocationInAreaParams {
  final String areaId;
  final double latitude;
  final double longitude;

  CheckLocationInAreaParams({
    required this.areaId,
    required this.latitude,
    required this.longitude,
  });
}
