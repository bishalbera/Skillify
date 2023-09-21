import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/domain/repos/course_repo.dart';

class GetCourses extends FutureUsecaseWithoutParams<List<Course>> {
  const GetCourses(this._repo);
  final CourseRepo _repo;

  @override
  ResultFuture<List<Course>> call() async => _repo.getCourses();
}
