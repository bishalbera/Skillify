import 'dart:io';

import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/datasource_utils.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/materials/data/models/resource_model.dart';
import 'package:skillify/src/course/features/materials/domain/entities/resource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    ResourceModel? resourceModel;
    try {
      await DataSourceUtils.authorizeUser(_client);

      if (material.isFile) {
        final materialFilePath =
            'courses/${material.courseId}/materials/${material.id}/material';
        await _dbClient
            .from('courses')
            .upload(
              materialFilePath,
              File(material.fileURL),
              fileOptions: const FileOptions(
                upsert: true,
              ),
            )
            .then((value) async {
          final url = _dbClient.from('courses').getPublicUrl(materialFilePath);
          final materialModel =
              (Resource as ResourceModel).copyWith(fileURL: url);
        });
      }

      if (resourceModel != null) {
        await _client.from('materials').upsert(resourceModel.toMap());
      }

      final response = await _client
          .from('courses')
          .select<PostgrestResponse>('numberOfMaterials')
          .eq('id', material.courseId)
          .single();
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
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<ResourceModel>> getMaterials(String courseId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final response = await _client
          .from('materials')
          .select<PostgrestResponse>()
          .eq('courseId', courseId);
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
