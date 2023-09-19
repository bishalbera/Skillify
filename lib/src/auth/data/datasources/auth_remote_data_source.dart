import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skillify/core/enums/update_user.dart';
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
  });

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> forgotPassword(String email);

  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required SupabaseClient client,
    required SupabaseStorageClient dbClient,
  })  : _client = client,
        _dbClient = dbClient;

  final SupabaseClient _client;
  final SupabaseStorageClient _dbClient;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.statusCode,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final session = result.session;

      final user = result.user;
      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(user.id);
      if (userData.isNotEmpty) {
        return LocalUserModel.fromMap(userData);
      }

      await _setUserData(user, email);
      userData = await _getUserData(user.id);
      return LocalUserModel.fromMap(userData);
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.statusCode,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      await _setUserData(res.user!, email);
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.statusCode,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.profilePic:
          final imagePath = '/${_client.auth.currentUser?.id}/profile_pics';

          // await _dbClient.createBucket('profile_pics');
          // await _dbClient.updateBucket(
          //   'profile_pics',
          //   const BucketOptions(public: true),
          // );
          await _dbClient.from('profile_pics').upload(
                imagePath,
                userData as File,
                fileOptions: const FileOptions(
                  upsert: true,
                ),
              );
          var url = _dbClient.from('profile_pics').getPublicUrl(imagePath);
          url = Uri.parse(url).replace(
            queryParameters: {
              'profilePic': DateTime.now().millisecondsSinceEpoch.toString()
            },
          ).toString();

          await _client.auth.updateUser(
            UserAttributes(
              data: {
                'profilePic': url,
              },
            ),
          );
          await _updateUserData({'profilePic': url});

        case UpdateUserAction.displayName:
          await _updateUserData({
            'name': userData as String,
          });
        case UpdateUserAction.email:
          await _client.auth
              .updateUser(UserAttributes(email: userData as String));
          await _updateUserData({
            'email': userData,
          });
        case UpdateUserAction.password:
          if (_client.auth.currentUser?.email == null) {
            throw const ServerException(
              message: 'User does not exist',
              statusCode: 'Insufficient Permission',
            );
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _client.auth.updateUser(
            UserAttributes(
              password: newData['newPassword'] as String,
            ),
          );

        case UpdateUserAction.bio:
          await _updateUserData({'bio': userData as String});
      }
    } on StorageException catch (e) {
      throw ServerException(
        message: e.message ?? 'storage error occured',
        statusCode: e.statusCode,
      );
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.statusCode,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<Map<String, dynamic>> _getUserData(String id) async {
    return await _client
        .from('users')
        .select<Map<String, dynamic>>()
        .eq('id', id)
        .single();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    try {
      final data = LocalUserModel(
        id: user.id,
        name: user.userMetadata!['name'].toString(),
        email: user.email?.toString() ?? fallbackEmail,
        profilePic: user.userMetadata!['profilePic'].toString() ?? '',
        points: 0,
        bio: '',
      );
      final response = await _client.from('users').upsert(data.toMap());
      // if (response.error != null) {
      //   print(response.error?.message);
      //   throw Exception(
      //     'failed to set user data: ${response.error?.message}',
      //   );
      // }
    } on PostgrestException catch (e) {
      print(e.message);
      throw ServerException(message: e.message, statusCode: e.code);
    }
  }

  Future<void> _updateUserData(DataMap data) async {
    await _client
        .from('users')
        .update(data)
        .eq('id', _client.auth.currentUser?.id);
  }
}
