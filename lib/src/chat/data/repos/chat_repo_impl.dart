import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/chat/data/datasources/chat_remote_data_source.dart';
import 'package:skillify/src/chat/domain/entities/group.dart';
import 'package:skillify/src/chat/domain/entities/message.dart';
import 'package:skillify/src/chat/domain/repos/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  const ChatRepoImpl(this._remoteDataSource);
  final ChatRemoteDataSource _remoteDataSource;

  @override
  ResultStream<List<Group>> getGroups() {
    // TODO: implement getGroups
    throw UnimplementedError();
  }

  @override
  ResultStream<List<Message>> getMessages(String groupId) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  ResultFuture<LocalUser> getUserById(String userId) async {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    // TODO: implement joinGroup
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    // TODO: implement leaveGroup
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> sendMessage(Message message) async {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
