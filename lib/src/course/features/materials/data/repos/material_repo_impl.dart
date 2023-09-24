import 'package:dartz/dartz.dart';
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/materials/data/datasource/material_remote_data_src.dart';
import 'package:skillify/src/course/features/materials/domain/entities/resource.dart';
import 'package:skillify/src/course/features/materials/domain/repos/material_repo.dart';

class MaterialRepoImpl implements MaterialRepo {
  const MaterialRepoImpl(this._remoteDataSource);

  final MaterialRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<void> addMaterial(Resource material) async {
    try {
      await _remoteDataSource.addMaterial(material);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Resource>> getMaterials(String courseId) async {
    try {
      final result = await _remoteDataSource.getMaterials(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
