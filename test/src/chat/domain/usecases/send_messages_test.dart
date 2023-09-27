import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/src/chat/domain/entities/message.dart';
import 'package:skillify/src/chat/domain/usecases/send_message.dart';

import 'chat_repo.mock.dart';

void main() {
  late MockChatRepo repo;
  late SendMessage usecase;

  final tMessage = Message.empty();

  setUp(() {
    repo = MockChatRepo();
    usecase = SendMessage(repo);
    registerFallbackValue(tMessage);
  });

  test(
    'should call sendMessage on repo with the given message',
    () async {
      when(() => repo.sendMessage(any()))
          .thenAnswer((_) async => const Right(null));

      await usecase(tMessage);

      verify(() => repo.sendMessage(tMessage)).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
