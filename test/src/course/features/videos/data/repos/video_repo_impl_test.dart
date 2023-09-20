import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/src/course/features/videos/data/datasources/video_remote_data_src.dart';
import 'package:skillify/src/course/features/videos/data/models/video_model.dart';
import 'package:skillify/src/course/features/videos/data/repos/video_repo_impl.dart';
import 'package:skillify/src/course/features/videos/domain/entities/video.dart';

class MockVideoRemoteDataSrc extends Mock implements VideoRemoteDataSrc {}

void main() {
  late VideoRemoteDataSrc remoteDataSrc;
  late VideoRepoImpl repoImpl;

  final tVideo = VideoModel.empty();

  setUp(
    () {
      remoteDataSrc = MockVideoRemoteDataSrc();
      repoImpl = VideoRepoImpl(remoteDataSrc);
      registerFallbackValue(tVideo);
    },
  );

  const tException =
      ServerException(message: 'message', statusCode: 'statusCode');

  group(
    'addVideo',
    () {
      test(
        'should complete successfully when call to remote source is '
        'successful',
        () async {
          when(() => remoteDataSrc.addVideo(any()))
              .thenAnswer((_) async => Future.value());

          final result = await repoImpl.addVideo(tVideo);
          expect(result, equals(const Right<dynamic, void>(null)));
          verify(() => remoteDataSrc.addVideo(tVideo)).called(1);
          verifyNoMoreInteractions(remoteDataSrc);
        },
      );

      test(
        'should return [ServerFailure] when call to remote source is '
        'unsuccessful',
        () async {
          when(() => remoteDataSrc.addVideo(tVideo)).thenThrow(tException);

          final result = await repoImpl.addVideo(tVideo);

          expect(
            result,
            equals(
              Left<ServerFailure, dynamic>(
                ServerFailure.fromException(tException),
              ),
            ),
          );
          verify(() => remoteDataSrc.addVideo(tVideo)).called(1);
          verifyNoMoreInteractions(remoteDataSrc);
        },
      );
    },
  );

  group(
    'getVideos',
    () {
      test(
        'should return [List<Video>] when call to remote source is successful',
        () async {
          when(() => remoteDataSrc.getVideos(any()))
              .thenAnswer((_) async => [tVideo]);
          final result = await repoImpl.getVideos('courseId');

          expect(result, isA<Right<dynamic, List<Video>>>());
          verify(() => remoteDataSrc.getVideos('courseId')).called(1);
          verifyNoMoreInteractions(remoteDataSrc);
        },
      );
      test(
        'should return [ServerFailure] when call to remote source is '
        'unsuccessful',
        () async {
          when(() => remoteDataSrc.getVideos(any())).thenThrow(tException);
          final result = await repoImpl.getVideos('courseId');

          expect(
            result,
            equals(
              Left<ServerFailure, dynamic>(
                ServerFailure.fromException(tException),
              ),
            ),
          );
          verify(() => remoteDataSrc.getVideos('courseId')).called(1);
          verifyNoMoreInteractions(remoteDataSrc);
        },
      );
    },
  );
}
