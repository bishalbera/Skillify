import 'package:skillify/core/enums/update_user.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> forgotPassword(String email) {
    throw UnimplementedError();
  }

  @override
  ResultFuture<LocalUser> signIn(
      {required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> signUp(
      {required String email, required String name, required String password}) {
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> updateUser({required UpdateUserAction action, userData}) {
    throw UnimplementedError();
  }
}
