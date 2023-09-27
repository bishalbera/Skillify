import 'dart:io';

import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/datasource_utils.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/materials/data/models/resource_model.dart';
import 'package:skillify/src/course/features/materials/domain/entities/resource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class MaterialRemoteDataSrc {
  Future<List<ResourceModel>> getMaterials(String courseId);

  Future<void> addMaterial(Resource material);
}

class MaterialRemoteDataSrcImpl implements MaterialRemoteDataSrc {
  MaterialRemoteDataSrcImpl({
    required SupabaseClient client,
    required SupabaseStorageClient dbClient,
  })  : _client = client,
        _dbClient = dbClient;

  final SupabaseClient _client;
  final SupabaseStorageClient _dbClient;

  @override
  Future<void> addMaterial(Resource material) async {
    // ResourceModel? resourceModel;
    try {
      await DataSourceUtils.authorizeUser(_client);

      var materialModel =
          (material as ResourceModel).copyWith(id: const Uuid().v1());
      final id = materialModel.id;

      if (material.isFile) {
        final materialFilePath =
            'courses/${material.courseId}/materials/$id/material';
        final materialRef = await _dbClient
            .from('courses')
            .upload(
              materialFilePath,
              File(materialModel.fileURL),
              fileOptions: const FileOptions(
                upsert: true,
              ),
            )
            .then((value) async {
          final url = _dbClient.from('courses').getPublicUrl(materialFilePath);
          materialModel = materialModel.copyWith(fileURL: url);
        });
      }

      await _client.from('materials').upsert(materialModel.toMap());

      final response = await _client
          .from('courses')
          .select('numberOfMaterials')
          .eq('id', material.courseId)
          .single()
          .execute();
      final currentNumberOfMaterials = response.data!['numberOfMaterials'];

      final updateResponse = await _client.from('courses').update({
        'numberOfMaterials': currentNumberOfMaterials + 1,
      }).eq('id', material.courseId);
    } on StorageException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occured',
        statusCode: e.statusCode,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      print(e);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<ResourceModel>> getMaterials(String courseId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final response = await _client
          .from('materials')
          .select()
          .eq('courseId', courseId)
          .execute();
      return (response.data as List)
          .map((material) => ResourceModel.fromMap(material as DataMap))
          .toList();
    } on StorageException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occured',
        statusCode: e.statusCode,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
