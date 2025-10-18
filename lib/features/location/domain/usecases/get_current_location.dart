import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_data.dart';
import '../repositories/location_repository.dart';

@injectable
class GetCurrentLocation implements UseCase<LocationData, NoParams> {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, LocationData>> call(NoParams params) async {
    return await repository.getCurrentLocation();
  }
}
