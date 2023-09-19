import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/videos/domain/entities/video.dart';

abstract class VideoRepo {
  const VideoRepo();

  ResultFuture<List<Video>> getVideos(String courseId);

  ResultFuture<void> addVideo(Video video);
}
