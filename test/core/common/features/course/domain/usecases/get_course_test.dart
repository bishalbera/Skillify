import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/domain/repos/course_repo.dart';
import 'package:skillify/src/course/domain/usecases/get_courses.dart';

import 'course_repo.mock.dart';

void main() {
  late CourseRepo repo;
  late GetCourses usecase;

  setUp(
    () {
      repo = MockCourseRepo();
      usecase = GetCourses(repo);
    },
  );

  test(
    'should get courses from the repo',
    () async {
      when(() => repo.getCourses()).thenAnswer((_) async => const Right([]));

      final result = await usecase();

      expect(result, const Right<dynamic, List<Course>>([]));
      verify(() => repo.getCourses()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
