import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/area.dart';
import '../repositories/area_repository.dart';

@injectable
class GetAreas implements UseCase<List<Area>, NoParams> {
  final AreaRepository repository;

  GetAreas(this.repository);

  @override
  Future<Either<Failure, List<Area>>> call(NoParams params) async {
    return await repository.getAreas();
  }
}
