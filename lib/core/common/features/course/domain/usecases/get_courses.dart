import 'package:skillify/core/common/features/course/domain/entities/course.dart';
import 'package:skillify/core/common/features/course/domain/repos/course_repo.dart';
import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';

class GetCourses extends UseCaseWithoutParams<List<Course>> {
  const GetCourses(this._repo);
  final CourseRepo _repo;

  @override
  ResultFuture<List<Course>> call() async => _repo.getCourses();
}