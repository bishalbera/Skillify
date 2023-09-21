// ignore_for_file: constant_identifier_names

import 'package:skillify/core/res/media_res.dart';

enum NotificationCategory {
  TEST(value: 'test', image: MediaRes.test),
  VIDEO(value: 'video', image: MediaRes.video),
  MATERIAL(value: 'material', image: MediaRes.material),
  COURSE(value: 'course', image: MediaRes.course),
  NONE(value: 'none', image: MediaRes.course);

  const NotificationCategory({required this.value, required this.image});

  final String value;
  final String image;
}
