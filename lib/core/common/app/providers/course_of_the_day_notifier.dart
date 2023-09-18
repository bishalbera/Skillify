import 'package:flutter/material.dart';
import 'package:skillify/src/course/domain/entities/course.dart';

class CourseOfTheDayNotifier extends ChangeNotifier {
  Course? _courseOfTheDay;
  Course? get courseOfTheDay => _courseOfTheDay;

  void setCourseOfTheDay(Course course) {
    _courseOfTheDay ??= course;
    notifyListeners();
  }
}
