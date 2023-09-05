import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/src/auth/domain/usecases/sign_up.dart';

import 'auth_repo_mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp usecase;

  const tEmail = 'Test email';
  const tPassword = 'Test password';
  const tName = 'Test name';

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });

  test(
    'should call the [AuthRepo]',
    () async {
      when(
        () => repo.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );
      final result = await usecase(
        const SignUpParams(
          email: tEmail,
          password: tPassword,
          name: tName,
        ),
      );
      expect(result, const Right<dynamic, void>(null));

      verify(
        () => repo.signUp(
          email: tEmail,
          password: tPassword,
          name: tName,
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
