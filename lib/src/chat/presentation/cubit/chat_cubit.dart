import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/chat/domain/entities/group.dart';
import 'package:skillify/src/chat/domain/entities/message.dart';
import 'package:skillify/src/chat/domain/usecases/get_groups.dart';
import 'package:skillify/src/chat/domain/usecases/get_messages.dart';
import 'package:skillify/src/chat/domain/usecases/get_user_by_id.dart';
import 'package:skillify/src/chat/domain/usecases/join_group.dart';
import 'package:skillify/src/chat/domain/usecases/leave_group.dart';
import 'package:skillify/src/chat/domain/usecases/send_message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required GetGroups getGroups,
    required GetMessages getMessages,
    required GetUserById getUserById,
    required JoinGroup joinGroup,
    required LeaveGroup leaveGroup,
    required SendMessage sendMessage,
  })  : _getGroups = getGroups,
        _getMessages = getMessages,
        _getUserById = getUserById,
        _joinGroup = joinGroup,
        _leaveGroup = leaveGroup,
        _sendMessage = sendMessage,
        super(const ChatInitial());

  final GetGroups _getGroups;
  final GetMessages _getMessages;
  final GetUserById _getUserById;
  final JoinGroup _joinGroup;
  final LeaveGroup _leaveGroup;
  final SendMessage _sendMessage;

  Future<void> sendMessage(Message message) async {
    emit(const SendingMessage());
    final result = await _sendMessage(message);
    result.fold(
      (failure) => emit(ChatError(failure.errorMessage)),
      (_) => emit(const MessageSent()),
    );
  }

  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    emit(const JoiningGroup());
    final result = await _joinGroup(
      JoinGroupParams(groupId: groupId, userId: userId),
    );
    result.fold(
      (failure) => emit(ChatError(failure.errorMessage)),
      (_) => emit(const JoinedGroup()),
    );
  }

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    emit(const LeavingGroup());
    final result = await _leaveGroup(
      LeaveGroupParams(groupId: groupId, userId: userId),
    );
    result.fold(
      (failure) => emit(ChatError(failure.errorMessage)),
      (_) => emit(const LeftGroup()),
    );
  }

  Future<void> getUser(String userId) async {
    emit(const GettingUser());
    final result = await _getUserById(userId);

    result.fold(
      (failure) => emit(ChatError(failure.errorMessage)),
      (user) => emit(UserFound(user)),
    );
  }

  void getGroups() {
    emit(const LoadingGroups());

    StreamSubscription<Either<Failure, List<Group>>>? subscription;

    subscription = _getGroups().listen(
      (result) {
        result.fold(
          (failure) => emit(ChatError(failure.errorMessage)),
          (groups) => emit(GroupsLoaded(groups)),
        );
      },
      onError: (dynamic error) {
        emit(ChatError(error.toString()));
        subscription?.cancel();
      },
      onDone: () => subscription?.cancel(),
    );
  }

  void getMessages(String groupId) {
    emit(const LoadingMessages());

    StreamSubscription<Either<Failure, List<Message>>>? subscription;

    subscription = _getMessages(groupId).listen(
      (result) {
        result.fold(
          (failure) => emit(ChatError(failure.errorMessage)),
          (messages) => emit(MessagesLoaded(messages)),
        );
      },
      onError: (dynamic error) {
        emit(ChatError(error.toString()));
        subscription?.cancel();
      },
      onDone: () => subscription?.cancel(),
    );
  }
}
