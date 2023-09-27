import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/chat/domain/usecases/get_user_by_id.dart';

import 'chat_repo.mock.dart';

void main() {
  late MockChatRepo repo;
  late GetUserById usecase;

  setUp(() {
    repo = MockChatRepo();
    usecase = GetUserById(repo);
  });

  const tLocalUser = LocalUser.empty();

  test(
    'should return [LocalUser] from [UserRepo.getUserById]',
    () async {
      when(
        () => repo.getUserById(any()),
      ).thenAnswer((_) async => const Right(tLocalUser));

      final result = await usecase('userId');

      expect(result, const Right<dynamic, LocalUser>(tLocalUser));

      verify(
        () => repo.getUserById('userId'),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
