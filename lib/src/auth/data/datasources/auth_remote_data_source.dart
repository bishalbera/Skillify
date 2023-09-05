import 'package:skillify/core/enums/update_user.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';

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
