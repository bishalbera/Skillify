import 'package:skillify/core/common/features/course/domain/entities/course.dart';
import 'package:skillify/core/common/features/course/domain/repos/course_repo.dart';
import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';

class AddCourse extends UseCaseWithParams<void, Course> {
  const AddCourse(this._repo);
  final CourseRepo _repo;

  @override
  ResultFuture<void> call(Course params) async => _repo.addCourse(params);
}
