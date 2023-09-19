import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/src/course/features/videos/domain/entities/video.dart';
import 'package:skillify/src/course/features/videos/domain/repos/video_repo.dart';
import 'package:skillify/src/course/features/videos/domain/usecases/get_videos.dart';

import 'video_repo.mock.dart';

void main() {
  late VideoRepo repo;
  late GetVideos usecase;

  setUp(
    () {
      repo = MockVideoRepo();
      usecase = GetVideos(repo);
    },
  );

  final tVideo = Video.empty();

  test(
    'should call [VideoRepo.getVideos]',
    () async {
      when(() => repo.getVideos(any()))
          .thenAnswer((_) async => Right([tVideo]));

      final result = await usecase('testId');

      expect(result, isA<Right<dynamic, List<Video>>>());
      verify(() => repo.getVideos('testId')).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
