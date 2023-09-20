import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/materials/domain/entities/resource.dart';
import 'package:skillify/src/course/features/materials/domain/repos/material_repo.dart';

class GetMaterials extends UseCaseWithParams<List<Resource>, String> {
  const GetMaterials(this._repo);
  final MaterialRepo _repo;

  @override
  ResultFuture<List<Resource>> call(String params) =>
      _repo.getMaterials(params);
}
