import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.videoURL,
    required super.courseId,
    required super.uploadDate,
    super.thumbnailIsFile = false,
    super.thumbnail,
    super.title,
    super.tutor,
  });

  VideoModel.empty()
      : this(
          id: '_empty.id',
          videoURL: '_empty.videoURL',
          uploadDate: DateTime.now(),
          courseId: '_empty.courseId',
        );

  VideoModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          videoURL: map['videoURL'] as String,
          courseId: map['courseId'] as String,
          uploadDate: DateTime.parse(map['uploadDate'] as String),
          thumbnail: map['thumbnail'] as String?,
          title: map['title'] as String?,
          tutor: map['tutor'] as String?,
        );

  VideoModel copyWith({
    String? id,
    String? thumbnail,
    String? videoURL,
    String? title,
    String? tutor,
    String? courseId,
    DateTime? uploadDate,
    bool? thumbnailIsFile,
  }) {
    return VideoModel(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      videoURL: videoURL ?? this.videoURL,
      title: title ?? this.title,
      tutor: tutor ?? this.tutor,
      courseId: courseId ?? this.courseId,
      uploadDate: uploadDate ?? this.uploadDate,
      thumbnailIsFile: thumbnailIsFile ?? this.thumbnailIsFile,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'videoURL': videoURL,
      'title': title,
      'tutor': tutor,
      'courseId': courseId,
      'uploadDate': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
