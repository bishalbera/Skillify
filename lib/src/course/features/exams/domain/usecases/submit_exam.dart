import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:skillify/src/course/features/exams/domain/repos/exam_repo.dart';

class SubmitExam extends UseCaseWithParams<void, UserExam> {
  const SubmitExam(this._repo);

  final ExamRepo _repo;

  @override
  ResultFuture<void> call(UserExam params) => _repo.submitExam(params);
}
