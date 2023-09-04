import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/src/on_boarding/data/dataSources/on_boarding_local_data_sources.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    prefs = MockSharedPreferences();
    localDataSource = OnBoardingLocalDataSrcImpl(prefs);
  });

  group(
    'CacheFirstTimer',
    () {
      test(
        'should call the [sharedPreferences] to cache the data',
        () async {
          when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

          await localDataSource.cacheFirstTimer();

          verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
          verifyNoMoreInteractions(prefs);
        },
      );
      test(
        'should throw a [CacheException] when there is an error caching the data',
        () {
          when(() => prefs.setBool(any(), any())).thenThrow(Exception());
          final methodCall = localDataSource.cacheFirstTimer;

          expect(methodCall, throwsA(isA<CacheException>()));
          verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
          verifyNoMoreInteractions(prefs);
        },
      );
    },
  );
  group(
    'checkIfUserIsFirstTimer',
    () {
      test(
        'should call [SharedPreferences] to check if user is first timer and '
        'return the right response  from the storage',
        () async {
          when(() => prefs.getBool(any())).thenReturn(false);
          final result = await localDataSource.checkIfUserIsFirstTimer();

          expect(result, false);

          verify(() => prefs.getBool(kFirstTimerKey)).called(1);
          verifyNoMoreInteractions(prefs);
        },
      );

      test(
        'should return true if there is no data found in storage',
        () async {
          when(() => prefs.getBool(any())).thenReturn(null);

          final result = await localDataSource.checkIfUserIsFirstTimer();

          expect(result, true);

          verify(() => prefs.getBool(kFirstTimerKey)).called(1);

          verifyNoMoreInteractions(prefs);
        },
      );
      test(
        'should throw [CacheException] when there is an error '
        'retrieving the data',
        () async {
          when(() => prefs.getBool(any())).thenThrow(Exception());

          final call = localDataSource.checkIfUserIsFirstTimer;

          expect(call, throwsA(isA<CacheException>()));
          verify(() => prefs.getBool(kFirstTimerKey)).called(1);
          verifyNoMoreInteractions(prefs);
        },
      );
    },
  );
}
