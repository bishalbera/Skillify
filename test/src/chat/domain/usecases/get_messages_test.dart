import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/src/chat/domain/entities/message.dart';
import 'package:skillify/src/chat/domain/usecases/get_messages.dart';

import 'chat_repo.mock.dart';

void main() {
  late MockChatRepo repo;
  late GetMessages usecase;

  setUp(() {
    repo = MockChatRepo();
    usecase = GetMessages(repo);
  });

  test(
    'should emit [List<Message>] from the [ChatRepo]',
    () async {
      final expectedMessages = [
        Message(
          id: '1',
          groupId: '1',
          senderId: '1',
          message: 'Hello',
          timestamp: DateTime.now(),
        ),
        Message(
          id: '2',
          groupId: '1',
          senderId: '2',
          message: 'Hi',
          timestamp: DateTime.now(),
        ),
      ];

      when(() => repo.getMessages(any())).thenAnswer(
        (_) => Stream.value(
          Right(expectedMessages),
        ),
      );

      final stream = usecase('groupId');

      expect(
        stream,
        emitsInOrder([Right<Failure, List<Message>>(expectedMessages)]),
      );

      verify(() => repo.getMessages('groupId')).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
