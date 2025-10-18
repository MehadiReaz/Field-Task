import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

@injectable
class ValidateProximity implements UseCase<bool, ValidateProximityParams> {
  final LocationRepository repository;

  ValidateProximity(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateProximityParams params) async {
    return await repository.isWithinProximity(
      currentLatitude: params.currentLatitude,
      currentLongitude: params.currentLongitude,
      targetLatitude: params.targetLatitude,
      targetLongitude: params.targetLongitude,
      thresholdMeters: params.thresholdMeters,
    );
  }
}

class ValidateProximityParams {
  final double currentLatitude;
  final double currentLongitude;
  final double targetLatitude;
  final double targetLongitude;
  final double thresholdMeters;

  ValidateProximityParams({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.targetLatitude,
    required this.targetLongitude,
    this.thresholdMeters = 100.0,
  });
}
