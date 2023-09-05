import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/repos/auth_repo.dart';

class ForgotPassword extends UseCaseWithParams<void, String> {
  const ForgotPassword(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String params) {
    return _repo.forgotPassword(params);
  }
}
