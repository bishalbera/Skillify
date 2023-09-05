import 'package:equatable/equatable.dart';
import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/repos/auth_repo.dart';

class SignUp extends UseCaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
        email: params.email,
        password: params.password,
        name: params.name,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });

  const SignUpParams.empty() : this(email: '', password: '', name: '');

  final String email;
  final String password;
  final String name;

  @override
  List<String> get props => [email, password, name];
}
