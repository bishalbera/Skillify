import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/src/course/features/videos/domain/entities/video.dart';
import 'package:skillify/src/course/features/videos/domain/repos/video_repo.dart';
import 'package:skillify/src/course/features/videos/domain/usecases/add_video.dart';

import 'video_repo.mock.dart';

void main() {
  late VideoRepo repo;
  late AddVideo usecase;

  final tVideo = Video.empty();

  setUp(
    () {
      repo = MockVideoRepo();
      usecase = AddVideo(repo);
      registerFallbackValue(tVideo);
    },
  );

  test(
    'should call [VideoRepo.addVideo]',
    () async {
      when(() => repo.addVideo(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tVideo);

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => repo.addVideo(tVideo)).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
