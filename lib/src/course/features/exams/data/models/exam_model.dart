import 'dart:convert';

import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/exams/data/models/exam_question_model.dart';
import 'package:skillify/src/course/features/exams/domain/entities/exam.dart';
import 'package:skillify/src/course/features/exams/domain/entities/exam_question.dart';

class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.description,
    required super.timeLimit,
    super.imageUrl,
    super.questions,
  });

  factory ExamModel.fromJson(String source) =>
      ExamModel.fromUploadMap(jsonDecode(source) as DataMap);

  const ExamModel.empty()
      : this(
          id: 'Test String',
          courseId: 'Test String',
          title: 'Test String',
          description: 'Test String',
          timeLimit: 0,
          questions: const [],
        );

  ExamModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          courseId: map['courseId'] as String,
          title: map['title'] as String,
          description: map['description'] as String,
          timeLimit: (map['timeLimit'] as num).toInt(),
          imageUrl: map['imageUrl'] as String?,
          questions: null,
        );

  ExamModel.fromUploadMap(DataMap map)
      : this(
          id: map['id'] as String? ?? '',
          courseId: map['courseId'] as String? ?? '',
          title: map['title'] as String,
          description: map['Description'] as String,
          timeLimit: (map['time_seconds'] as num).toInt(),
          imageUrl: (map['image_url'] as String).isEmpty
              ? null
              : map['image_url'] as String,
          questions: List<DataMap>.from(map['questions'] as List<dynamic>)
              .map(ExamQuestionModel.fromUploadMap)
              .toList(),
        );

  ExamModel copyWith({
    String? id,
    String? courseId,
    List<ExamQuestion>? questions,
    String? title,
    String? description,
    int? timeLimit,
    String? imageUrl,
  }) {
    return ExamModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      questions: questions ?? this.questions,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLimit: timeLimit ?? this.timeLimit,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'imageUrl': imageUrl,
    };
  }
}
