import 'dart:convert';

import 'package:flutter/foundation.dart';
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
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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
          .select()
          .eq('examId', exam.id)
          .execute();

      final questions = response.data as List<dynamic>;

      final resultList = <ExamQuestionModel>[];

      for (final question in questions) {
        resultList.add(ExamQuestionModel.fromMap(question as DataMap));
      }

      return resultList;
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
          .select()
          .eq('courseId', courseId)
          .execute();

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
          .from('userExam')
          .select()
          .eq('courseId', courseId)
          .execute();
      final exams = response.data as List<dynamic>;
      print('fromgetusercourseexam: $exams');
      return exams
          .map((examData) => UserExamModel.fromMap(examData as DataMap))
          .toList();
    } on PostgrestException catch (e) {
      print(e.message);
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
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
          .select('enrolledCourseIds')
          .eq('id', userId)
          .single()
          .execute();
      final coursesIds = response.data!['enrolledCourseIds'] as List<dynamic>;
      final exams = <UserExamModel>[];
      for (final courseId in coursesIds) {
        final courseExams = await getUserCourseExams(courseId.toString());
        print('courseexams: ${courseExams.length}');
        exams.addAll(courseExams);
        print(exams.first.answers);
        print(exams.first.totalQuestions);
      }
      return exams;
    } on PostgrestException catch (e) {
      print(e.message);
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
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
        'id': exam.courseId,
        'examTitle': exam.examTitle,
      });

      await _client.from('userExam').upsert((exam as UserExamModel).toMap());

      // Calculate points
      final totalPoints = exam.answers
          .where((answer) => answer.isCorrect)
          .fold<int>(0, (previousValue, _) => previousValue + 1);

      print('submitexam: ${exam.totalQuestions}');

      final pointPercent = totalPoints / exam.totalQuestions;
      final points = pointPercent * 100;

      final response = await _client
          .from('users')
          .select('points')
          .eq('id', userId)
          .single()
          .execute();
      final currentPoints = response.data!['points'];

      await _client
          .from('users')
          .update({'points': currentPoints + points}).eq('id', userId);
      for (final answer in exam.answers) {
        await _client.from('userChoice').upsert({
          'questionId': answer.questionId,
          'userChoice': answer.userChoice,
          'correctChoice': answer.correctChoice,
        });
      }

      final userData = await _client
          .from('users')
          .select('enrolledCourseIds')
          .eq('id', userId)
          .single()
          .execute();

      final enrolledCourseIds = userData.data['enrolledCourseIds'];

      if (enrolledCourseIds is List<String>) {
        if (!enrolledCourseIds.contains(exam.courseId)) {
          enrolledCourseIds.add(exam.courseId);

          await _client.from('users').update(
            {'enrolledCourseIds': enrolledCourseIds},
          ).eq('id', userId);
        }
      } else if (enrolledCourseIds is List) {
        final updatedCourseIds = [
          ...enrolledCourseIds.map((item) => item.toString())
        ];

        if (!updatedCourseIds.contains(exam.courseId)) {
          updatedCourseIds.add(exam.courseId);

          await _client
              .from('users')
              .update({'enrolledCourseIds': updatedCourseIds}).eq('id', userId);
        }
      } else {}
    } on PostgrestException catch (e, s) {
      print(e.message);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
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
      final examId =
          (await _client.from('exams').select('id').single())['id'] as String;
      if (kDebugMode) {
        print('from remoredatasrc: $examId');
      }

      final questions = exam.questions;
      if (questions != null && questions.isNotEmpty) {
        for (final question in questions) {
          var questionToUpload = (question as ExamQuestionModel)
              .copyWith(courseId: exam.courseId, examId: examId);

          final newChoices = <QuestionChoiceModel>[];
          for (final choice in questionToUpload.choices) {
            final newChoice = (choice as QuestionChoiceModel).copyWith(
              questionId: const Uuid().v4(),
            );
            print('choice: ${newChoice.questionId}');
            newChoices.add(newChoice);
          }
          questionToUpload = questionToUpload.copyWith(
            choices: newChoices,
            id: const Uuid().v4(),
          );

          final questionRes =
              await _client.from('questions').insert(questionToUpload.toMap());

          print(questionRes);
        }
        final response = await _client
            .from('courses')
            .select('numberOfExams')
            .eq('id', exam.courseId)
            .single()
            .execute();
        final currentNumberOfExams = response.data!['numberOfExams'];

        final updateResponse = await _client.from('courses').update({
          'numberOfExams': currentNumberOfExams + 1,
        }).eq('id', exam.courseId);
      }
    } on PostgrestException catch (e, s) {
      debugPrintStack(stackTrace: s);
      print(e.message);
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      print(e);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
