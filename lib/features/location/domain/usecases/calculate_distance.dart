import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

@injectable
class CalculateDistance implements UseCase<double, CalculateDistanceParams> {
  final LocationRepository repository;

  CalculateDistance(this.repository);

  @override
  Future<Either<Failure, double>> call(CalculateDistanceParams params) async {
    return await repository.calculateDistance(
      startLatitude: params.startLatitude,
      startLongitude: params.startLongitude,
      endLatitude: params.endLatitude,
      endLongitude: params.endLongitude,
    );
  }
}

class CalculateDistanceParams {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  CalculateDistanceParams({
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });
}
