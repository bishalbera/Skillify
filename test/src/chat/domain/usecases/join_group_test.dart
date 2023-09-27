import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/src/chat/domain/usecases/join_group.dart';

import 'chat_repo.mock.dart';

void main() {
  late MockChatRepo repo;
  late JoinGroup usecase;

  setUp(() {
    repo = MockChatRepo();
    usecase = JoinGroup(repo);
  });

  const tJoinGroupParams = JoinGroupParams.empty();

  test(
    'should call the [ChatRepo.joinGroup]',
    () async {
      when(
        () => repo.joinGroup(
          groupId: any(named: 'groupId'),
          userId: any(named: 'userId'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(tJoinGroupParams);

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => repo.joinGroup(
          groupId: tJoinGroupParams.groupId,
          userId: tJoinGroupParams.userId,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
