import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/src/on_boarding/data/dataSources/on_boarding_local_data_sources.dart';
import 'package:skillify/src/on_boarding/data/repos/on_boarding_repo_impl.dart';

class MockOnBoardingLocalDataSource extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSource();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test('should be a subClass of [OnBoardingRepo]', () {
    expect(repoImpl, isA<OnBoardingRepoImpl>());
  });

  group(
    'cacheFirstTimer',
    () {
      test(
        'should complete successfully when call to local source is successful',
        () async {
          when(() => localDataSource.cacheFirstTimer()).thenAnswer(
            (_) async => Future.value(),
          );
          final result = await repoImpl.cacheFirstTimer();
          expect(
            result,
            equals(
              const Right<dynamic, void>(null),
            ),
          );
          verify(() => localDataSource.cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
      test(
        ' should return [CacheFailure] when call to local source is '
        'unsuccessful',
        () async {
          when(() => localDataSource.cacheFirstTimer()).thenThrow(
            const CacheException(message: 'Insufficient storage'),
          );
          final result = await repoImpl.cacheFirstTimer();
          expect(
            result,
            equals(
              Left<CacheFailure, dynamic>(
                CacheFailure(message: 'Insufficient storage', statusCode: 500),
              ),
            ),
          );
          verify(() => localDataSource.cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
    },
  );

  group(
    'checkIfUserIsFirstTimer',
    () {
      test(
        'should return true if user is first timer',
        () async {
          when(() => localDataSource.checkIfUserIsFirstTimer()).thenAnswer(
            (_) async => Future.value(true),
          );
          final result = await repoImpl.checkIfUserIsFirstTimer();
          expect(
            result,
            equals(const Right<dynamic, bool>(true)),
          );
          verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
      test(
        'should return false when the user is not first timer',
        () async {
          when(() => localDataSource.checkIfUserIsFirstTimer()).thenAnswer(
            (_) async => Future.value(false),
          );
          final result = await repoImpl.checkIfUserIsFirstTimer();
          expect(
            result,
            equals(const Right<dynamic, bool>(false)),
          );
          verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
      test(
        'should return [CacheFailure] when call to local source is '
        'unsuccessful',
        () async {
          when(() => localDataSource.checkIfUserIsFirstTimer()).thenThrow(
            const CacheException(
              message: 'Insufficient storage',
              statusCode: 403,
            ),
          );
          final result = await repoImpl.checkIfUserIsFirstTimer();
          expect(
            result,
            equals(
              Left<CacheFailure, dynamic>(
                CacheFailure(message: 'Insufficient storage', statusCode: 403),
              ),
            ),
          );
          verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
    },
  );
}
