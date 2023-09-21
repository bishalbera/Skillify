import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/datasource_utils.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/exams/data/models/exam_model.dart';
import 'package:skillify/src/course/features/exams/data/models/exam_question_model.dart';
import 'package:skillify/src/course/features/exams/data/models/question_choice_model.dart';
import 'package:skillify/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:skillify/src/course/features/exams/domain/entities/exam.dart';
import 'package:skillify/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ExamRemoteDataSrc {
  Future<List<ExamModel>> getExams(String courseId);

  Future<void> uploadExam(Exam exam);

  Future<List<ExamQuestionModel>> getExamQuestions(Exam exam);

  Future<void> updateExam(Exam exam);

  Future<void> submitExam(UserExam exam);

  Future<List<UserExamModel>> getUserExams();

  Future<List<UserExamModel>> getUserCourseExams(String courseId);
}

class ExamRemoteDataSrcImpl implements ExamRemoteDataSrc {
  const ExamRemoteDataSrcImpl({required SupabaseClient client})
      : _client = client;
  final SupabaseClient _client;

  @override
  Future<List<ExamQuestionModel>> getExamQuestions(Exam exam) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final response = await _client
          .from('questions')
          .select<PostgrestResponse>()
          .eq('exam_id', exam.id);

      final questions = response.data as List<dynamic>;
      return questions
          .map((e) => ExamQuestionModel.fromMap(e as DataMap))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<ExamModel>> getExams(String courseId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final response = await _client
          .from('exams')
          .select<PostgrestResponse>()
          .eq('courseId', courseId);

      final exams = response.data as List<dynamic>;
      return exams.map((e) => ExamModel.fromMap(e as DataMap)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<UserExamModel>> getUserCourseExams(String courseId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final response = await _client
          .from('exams')
          .select<PostgrestResponse>()
          .eq('courseId', courseId);
      final exams = response.data as List<dynamic>;
      return exams
          .map((examData) => UserExamModel.fromMap(examData as DataMap))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<UserExamModel>> getUserExams() async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final userId = _client.auth.currentUser!.id;
      final response = await _client
          .from('users')
          .select<PostgrestResponse>('enrolledCourseIds')
          .eq('id', userId)
          .single();
      final coursesIds = response.data!['enrolledCourseIds'] as List<dynamic>;
      final exams = <UserExamModel>[];
      for (final courseId in coursesIds) {
        final courseExams = await getUserCourseExams(courseId.toString());
        exams.addAll(courseExams);
      }
      return exams;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> submitExam(UserExam exam) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final userId = _client.auth.currentUser!.id;
      await _client.from('courses').upsert({
        'userId': userId,
        'courseId': exam.courseId,
        'courseName': exam.examTitle,
      });

      await _client.from('exams').upsert((exam as UserExamModel).toMap());

      // Calculate points
      final totalPoints = exam.answers
          .where((answer) => answer.isCorrect)
          .fold<int>(0, (previousValue, _) => previousValue + 1);

      final pointPercent = totalPoints / exam.totalQuestions;
      final points = pointPercent * 100;
      // Update user's points
      final response = await _client
          .from('users')
          .select<PostgrestResponse>('points')
          .eq('id', userId)
          .single();
      final currentPoints = response.data!['points'];

      await _client
          .from('users')
          .update({points: '$currentPoints + $points'}).eq('id', userId);
      // Check if user is already enrolled in the course
      final userData = await _client
          .from('users')
          .select<PostgrestResponse>('enrolledCourseIds')
          .eq('id', userId)
          .single();

      final alreadyEnrolled = (userData.data['enrolledCourseIds'] as List?)
              ?.contains(exam.courseId) ??
          false;

      //If not already enrolled, add course to user's enrolled courses
      if (!alreadyEnrolled) {
        await _client
            .from('users')
            .update({'enrolledCourseIds': exam.courseId}).eq('id', userId);
      }
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> updateExam(Exam exam) async {
    try {
      await DataSourceUtils.authorizeUser(_client);

      await _client
          .from('exams')
          .update((exam as ExamModel).toMap())
          .eq('id', exam.id);

      final questions = exam.questions;
      if (questions != null && questions.isNotEmpty) {
        for (final question in questions) {
          await _client
              .from('questions')
              .update((question as ExamQuestionModel).toMap())
              .eq('id', question.id);
        }
      }
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> uploadExam(Exam exam) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final examRes =
          await _client.from('exams').insert((exam as ExamModel).toMap());
      final examId = await _client.from('exams').select('id');

      final questions = exam.questions;
      if (questions != null && questions.isNotEmpty) {
        for (final question in questions) {
          var questionToUpload = (question as ExamQuestionModel).copyWith(
            examId: examId.toString(),
            courseId: exam.courseId,
          );

          final newChoices = <QuestionChoiceModel>[];
          for (final choice in questionToUpload.choices) {
            final newChoice = (choice as QuestionChoiceModel).copyWith(
              questionId: question.id,
            );
            newChoices.add(newChoice);
          }
          questionToUpload = questionToUpload.copyWith(choices: newChoices);

          final questionRes =
              await _client.from('questions').insert(questionToUpload.toMap());

          final response = await _client
              .from('courses')
              .select<PostgrestResponse>('numberOfExams')
              .eq('id', exam.courseId)
              .single();
          final currentNumberOfExams = response.data!['numberOfExams'];

          final updateResponse = await _client.from('courses').update({
            'numberOfExams': currentNumberOfExams + 1,
          }).eq('id', exam.courseId);
        }
      }
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
