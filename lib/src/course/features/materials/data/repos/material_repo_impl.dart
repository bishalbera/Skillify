import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/materials/data/datasource/material_remote_data_src.dart';
import 'package:skillify/src/course/features/materials/domain/entities/resource.dart';
import 'package:skillify/src/course/features/materials/domain/repos/material_repo.dart';

class MaterialRepoImpl implements MaterialRepo {
  const MaterialRepoImpl(this._remoteDataSource);

  final MaterialRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<void> addMaterial(Resource material) {
    // TODO: implement addMaterial
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<Resource>> getMaterials(String courseId) {
    // TODO: implement getMaterials
    throw UnimplementedError();
  }
}
