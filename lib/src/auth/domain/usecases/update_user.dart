import 'package:equatable/equatable.dart';
import 'package:skillify/core/enums/update_user.dart';
import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/repos/auth_repo.dart';

class UpdateUser extends FutureUsecaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call(UpdateUserParams params) {
    return _repo.updateUser(
      action: params.action,
      userData: params.userData,
    );
  }
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.action, required this.userData});

  const UpdateUserParams.empty()
      : this(action: UpdateUserAction.displayName, userData: '');

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<dynamic> get props => [action, userData];
}
