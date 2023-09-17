import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/data/datasources/course_remote_data_src.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/domain/repos/course_repo.dart';

class CourseRepoImpl implements CourseRepo {
  const CourseRepoImpl(this._remoteDataSrc);
  final CourseRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> addCourse(Course course) {
    // TODO: implement addCourse
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<Course>> getCourses() {
    // TODO: implement getCourses
    throw UnimplementedError();
  }
}
