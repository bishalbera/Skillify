part of 'course_cubit.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {
  const CourseInitial();
}

class LoadingCourse extends CourseState {
  const LoadingCourse();
}

class AddingCourse extends CourseState {
  const AddingCourse();
}

class CourseAdded extends CourseState {
  const CourseAdded();
}

class CourseLoaded extends CourseState {
  const CourseLoaded(this.courses);

  final List<Course> courses;

  @override
  List<Object> get props => [courses];
}

class CourseError extends CourseState {
  const CourseError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
