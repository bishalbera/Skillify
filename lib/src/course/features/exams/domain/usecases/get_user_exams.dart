import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:skillify/src/course/features/exams/domain/repos/exam_repo.dart';

class GetUserExams extends UseCaseWithoutParams<List<UserExam>> {
  const GetUserExams(this._repo);

  final ExamRepo _repo;

  @override
  ResultFuture<List<UserExam>> call() => _repo.getUserExams();
}
