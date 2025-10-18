import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/area_repository.dart';

@injectable
class DeleteArea implements UseCase<void, DeleteAreaParams> {
  final AreaRepository repository;

  DeleteArea(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAreaParams params) async {
    return await repository.deleteArea(params.id);
  }
}

class DeleteAreaParams {
  final String id;

  DeleteAreaParams({required this.id});
}
