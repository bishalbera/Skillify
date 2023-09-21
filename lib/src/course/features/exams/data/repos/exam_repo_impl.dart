import 'package:dartz/dartz.dart';
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/exams/data/datasources/exam_remote_data_src.dart';
import 'package:skillify/src/course/features/exams/domain/entities/exam.dart';
import 'package:skillify/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:skillify/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:skillify/src/course/features/exams/domain/repos/exam_repo.dart';

class ExamRepoImpl implements ExamRepo {
  const ExamRepoImpl(this._remoteDataSource);

  final ExamRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<ExamQuestion>> getExamQuestions(Exam exam) async {
    try {
      final result = await _remoteDataSource.getExamQuestions(exam);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Exam>> getExams(String courseId) async {
    try {
      final result = await _remoteDataSource.getExams(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserExam>> getUserCourseExams(String courseId) async {
    try {
      final result = await _remoteDataSource.getUserCourseExams(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserExam>> getUserExams() async {
    try {
      final result = await _remoteDataSource.getUserExams();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> submitExam(UserExam exam) async {
    try {
      await _remoteDataSource.submitExam(exam);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateExam(Exam exam) async {
    try {
      await _remoteDataSource.updateExam(exam);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> uploadExam(Exam exam) async {
    try {
      await _remoteDataSource.uploadExam(exam);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
