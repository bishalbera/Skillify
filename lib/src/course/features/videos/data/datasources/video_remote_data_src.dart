import 'package:skillify/src/course/features/videos/data/models/video_model.dart';
import 'package:skillify/src/course/features/videos/domain/entities/video.dart';

abstract class VideoRemoteDataSrc {
  Future<List<VideoModel>> getVideos(String courseId);

  Future<void> addVideo(Video video);
}
