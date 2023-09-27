import 'package:equatable/equatable.dart';
import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/chat/domain/repos/chat_repo.dart';

class LeaveGroup extends FutureUsecaseWithParams<void, LeaveGroupParams> {
  const LeaveGroup(this._repo);

  final ChatRepo _repo;

  @override
  ResultFuture<void> call(LeaveGroupParams params) => _repo.leaveGroup(
        groupId: params.groupId,
        userId: params.userId,
      );
}

class LeaveGroupParams extends Equatable {
  const LeaveGroupParams({required this.groupId, required this.userId});

  const LeaveGroupParams.empty()
      : groupId = '',
        userId = '';

  final String groupId;
  final String userId;

  @override
  List<String> get props => [groupId, userId];
}
