import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/exams/domain/entities/exam.dart';
import 'package:skillify/src/course/features/exams/domain/repos/exam_repo.dart';

class UploadExam extends UseCaseWithParams<void, Exam> {
  const UploadExam(this._repo);

  final ExamRepo _repo;
  @override
  ResultFuture<void> call(Exam params) => _repo.uploadExam(params);
}
