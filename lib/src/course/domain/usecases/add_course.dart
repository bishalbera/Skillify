import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/domain/repos/course_repo.dart';

class AddCourse extends FutureUsecaseWithParams<void, Course> {
  const AddCourse(this._repo);
  final CourseRepo _repo;

  @override
  ResultFuture<void> call(Course params) async => _repo.addCourse(params);
}
