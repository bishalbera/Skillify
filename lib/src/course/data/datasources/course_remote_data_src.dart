import 'dart:io';

import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/chat/data/models/group_model.dart';
import 'package:skillify/src/chat/domain/entities/group.dart';
import 'package:skillify/src/course/data/models/course_model.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

abstract class CourseRemoteDataSrc {
  const CourseRemoteDataSrc();

  Future<List<CourseModel>> getCourses();

  Future<void> addCourse(Course course);
}

class RemoteDataSrcImpl implements CourseRemoteDataSrc {
  const RemoteDataSrcImpl({
    required SupabaseClient client,
    required SupabaseStorageClient dbClient,
  })  : _client = client,
        _dbClient = dbClient;

  final SupabaseClient _client;
  final SupabaseStorageClient _dbClient;

  @override
  Future<void> addCourse(Course course) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }
      final courseRef = await _client.from('courses').select();
      final courseRefId = await _client.from('courses').select('id');
      final groupRef = await _client.from('groups').select();
      final groupRefId = await _client.from('groups').select('id');

      var courseModel = (course as CourseModel).copyWith(
        id: courseRefId as String,
        groupId: groupRefId as String,
      );
      if (courseModel.imageIsFile) {
        final imagePath = 'courses/${courseModel.id}/profile_image'
            '/${courseModel.title}-pfp';
        final imageRef = await _dbClient.from('courses').upload(
              imagePath,
              File(courseModel.image!),
              fileOptions: const FileOptions(
                upsert: true,
              ),
            );
        final url = _dbClient.from('courses').getPublicUrl(imagePath);
        courseModel = courseModel.copyWith(image: url);
      }
      await _client.from('users').upsert(courseModel.toMap());

      final group = GroupModel(
        id: groupRefId,
        name: course.title,
        courseId: courseRefId,
        members: const [],
        groupImageUrl: courseModel.image,
      );
      return await _client.from('groups').upsert(group.toMap());
    } on StorageException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occured',
        statusCode: e.statusCode,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }
      final response = await _client.from('courses').select().execute();
      final courses = response.data as List<dynamic>;
      return courses.map((courseMap) {
        return CourseModel.fromMap(courseMap as DataMap);
      }).toList();
    } on StorageException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occured',
        statusCode: e.statusCode,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
