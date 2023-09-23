import 'dart:io';

import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/datasource_utils.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/videos/data/models/video_model.dart';
import 'package:skillify/src/course/features/videos/domain/entities/video.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class VideoRemoteDataSrc {
  Future<List<VideoModel>> getVideos(String courseId);

  Future<void> addVideo(Video video);
}

class VideoRemoteDataSrcImpl implements VideoRemoteDataSrc {
  VideoRemoteDataSrcImpl({
    required SupabaseClient client,
    required SupabaseStorageClient dbClient,
  })  : _client = client,
        _dbClient = dbClient;

  final SupabaseClient _client;
  final SupabaseStorageClient _dbClient;

  @override
  Future<void> addVideo(Video video) async {
    //VideoModel? videoModel;
    try {
      await DataSourceUtils.authorizeUser(_client);

      var videoModel = (video as VideoModel).copyWith(
        id: const Uuid().v1(),
      );
      if (videoModel.thumbnailIsFile) {
        final imagePath =
            'courses/${video.courseId}/videos/${video.id}/thumbnail';
        final imageRef = await _dbClient
            .from('courses')
            .upload(
              imagePath,
              File(videoModel.thumbnail!),
              fileOptions: const FileOptions(
                upsert: true,
              ),
            )
            .then((value) async {
          final url = _dbClient.from('courses').getPublicUrl(imagePath);
          videoModel = videoModel.copyWith(thumbnail: url);
        });
      }
      await _client.from('videos').upsert(videoModel.toMap());

      final response = await _client
          .from('courses')
          .select('numberOfVideos')
          .eq('id', video.courseId)
          .single()
          .execute();
      final currentNumberOfVideos = response.data!['numberOfVideos'];

      final updateResponse = await _client.from('courses').update({
        'numberOfVideos': currentNumberOfVideos + 1,
      }).eq('id', video.courseId);
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
  Future<List<VideoModel>> getVideos(String courseId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final response = await _client
          .from('videos')
          .select()
          .eq('courseId', courseId)
          .execute();
      return (response.data as List)
          .map((video) => VideoModel.fromMap(video as DataMap))
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
