import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/src/course/data/models/course_model.dart';
import 'package:skillify/src/course/domain/usecases/add_course.dart';
import 'package:skillify/src/course/domain/usecases/get_courses.dart';
import 'package:skillify/src/course/presentation/cubit/course_cubit.dart';

class MockAddCourse extends Mock implements AddCourse {}

class MockGetCourses extends Mock implements GetCourses {}

void main() {
  late AddCourse addCourse;
  late GetCourses getCourses;
  late CourseCubit courseCubit;

  final tCourse = CourseModel.empty();

  setUp(() {
    addCourse = MockAddCourse();
    getCourses = MockGetCourses();
    courseCubit = CourseCubit(
      addCourse: addCourse,
      getCourses: getCourses,
    );
    registerFallbackValue(tCourse);
  });

  tearDown(() {
    courseCubit.close();
  });

  test(
    'initial state should be [CourseInitial]',
    () async {
      expect(courseCubit.state, const CourseInitial());
    },
  );

  group('addCourse', () {
    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseAdded] when addCourse is called',
      build: () {
        when(() => addCourse(any())).thenAnswer((_) async => const Right(null));
        return courseCubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => const <CourseState>[
        AddingCourse(),
        CourseAdded(),
      ],
      verify: (_) {
        verify(() => addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseError] when addCourse is called',
      build: () {
        when(() => addCourse(any())).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return courseCubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => const <CourseState>[
        AddingCourse(),
        CourseError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );
  });

  group('getCourses', () {
    blocTest<CourseCubit, CourseState>(
      'emits [CourseLoading, CoursesLoaded] when getCourses is called',
      build: () {
        when(() => getCourses()).thenAnswer((_) async => Right([tCourse]));
        return courseCubit;
      },
      act: (cubit) => cubit.getCourses(),
      expect: () => <CourseState>[
        const LoadingCourses(),
        CoursesLoaded([tCourse]),
      ],
      verify: (_) {
        verify(() => getCourses()).called(1);
        verifyNoMoreInteractions(getCourses);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [CourseLoading, CourseError] when getCourses is called',
      build: () {
        when(() => getCourses()).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return courseCubit;
      },
      act: (cubit) => cubit.getCourses(),
      expect: () => const <CourseState>[
        LoadingCourses(),
        CourseError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => getCourses()).called(1);
        verifyNoMoreInteractions(getCourses);
      },
    );
  });
}
