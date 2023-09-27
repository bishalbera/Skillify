import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/src/chat/data/models/group_model.dart';
import 'package:skillify/src/chat/domain/entities/group.dart';
import 'package:skillify/src/chat/domain/usecases/get_groups.dart';

import 'chat_repo.mock.dart';

void main() {
  late MockChatRepo repo;
  late GetGroups usecase;

  setUp(() {
    repo = MockChatRepo();
    usecase = GetGroups(repo);
  });

  test(
    'should emit [List<Group>] from the [ChatRepo]',
    () async {
      final expectedGroups = [
        GroupModel.empty().copyWith(
          id: '1',
          name: 'Group 1',
          courseId: '1',
        ),
        GroupModel.empty().copyWith(
          id: '2',
          name: 'Group 2',
          courseId: '1',
        ),
      ];

      when(() => repo.getGroups()).thenAnswer(
        (_) => Stream.value(
          Right(expectedGroups),
        ),
      );

      final stream = usecase();

      expect(
        stream,
        emitsInOrder([Right<Failure, List<Group>>(expectedGroups)]),
      );

      verify(() => repo.getGroups()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
