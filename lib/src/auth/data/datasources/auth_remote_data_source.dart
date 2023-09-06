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
  Future<LocalUserModel> signIn(
      {required String email, required String password}) {}

  @override
  Future<void> signUp(
      {required String email, required String name, required String password}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser({required UpdateUserAction action, userData}) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  Future<DataMap> _getUserData(String uid) async {
    return await _client.from('users').select().eq('uid', uid).single()
        as DataMap;
  }

  Future<void> _setUserData(User user, String fallbackEmail) async{
    final userMap = {
      'uid': user.id,
      'email': user.email ?? fallbackEmail,
      'name': user. ?? '',
      'profilePic': user.photoURL ?? '',
      'points': 0,
    };
  }
}
