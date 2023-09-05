import 'package:skillify/core/enums/update_user.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<void> forgotPassword(String email);

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String email,
    required String name,
    required String password,
  });

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}
