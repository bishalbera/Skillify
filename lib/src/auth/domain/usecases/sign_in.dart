import 'package:equatable/equatable.dart';
import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/auth/domain/repos/auth_repo.dart';

class SignIn extends UseCaseWithParams<LocalUser, SignInParams> {
  const SignIn(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<LocalUser> call(SignInParams params) => _repo.signIn(
        email: params.email,
        password: params.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });

  const SignInParams.empty()
      : email = '',
        password = '';

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}
