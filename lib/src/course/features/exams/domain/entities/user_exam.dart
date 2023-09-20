import 'package:equatable/equatable.dart';
import 'package:skillify/src/course/features/exams/domain/entities/user_choice.dart';

class UserExam extends Equatable {
  const UserExam({
    required this.examId,
    required this.courseId,
    required this.totalQuestions,
    required this.examTitle,
    required this.dateSubmitted,
    required this.answers,
    this.examImageUrl,
  });

  UserExam.empty([DateTime? date])
      : this(
          examId: 'Test String',
          courseId: 'Test String',
          totalQuestions: 0,
          examTitle: 'Test String',
          examImageUrl: 'Test String',
          dateSubmitted: date ?? DateTime.now(),
          answers: const [],
        );

  final String examId;
  final String courseId;
  final int totalQuestions;
  final String examTitle;
  final String? examImageUrl;
  final DateTime dateSubmitted;
  final List<UserChoice> answers;

  @override
  List<Object?> get props => [examId, courseId];
}
