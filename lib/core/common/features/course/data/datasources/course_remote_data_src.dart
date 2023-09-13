import 'package:skillify/core/common/features/course/data/models/course_model.dart';
import 'package:skillify/core/common/features/course/domain/entities/course.dart';

abstract class CourseRemoteDataSrc {
  const CourseRemoteDataSrc();

  Future<List<CourseModel>> getCourses();

  Future<void> addCourse(Course course);
}
