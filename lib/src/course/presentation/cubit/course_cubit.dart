import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/domain/usecases/add_course.dart';
import 'package:skillify/src/course/domain/usecases/get_courses.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit({
    required AddCourse addCourse,
    required GetCourses getCourses,
  })  : _addCourse = addCourse,
        _getCourses = getCourses,
        super(const CourseInitial());

  final AddCourse _addCourse;
  final GetCourses _getCourses;

  Future<void> addCourse(Course course) async {
    emit(const AddingCourse());
    final result = await _addCourse(course);
    result.fold(
      (failure) => emit(CourseError(failure.errorMessage)),
      (_) => emit(const CourseAdded()),
    );
  }

  Future<void> getCourses() async {
    emit(const LoadingCourses());
    final result = await _getCourses();
    result.fold(
      (failure) => emit(CourseError(failure.errorMessage)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }
}
