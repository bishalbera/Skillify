import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/src/auth/domain/usecases/forgot_password.dart';

import 'auth_repo_mock.dart';

void main() {
  late MockAuthRepo repo;
  late ForgotPassword useCase;

  setUp(() {
    repo = MockAuthRepo();
    useCase = ForgotPassword(repo);
  });

  test(
    'should call the [AuthRepo.forgotPassword]',
    () async {
      when(() => repo.forgotPassword(any())).thenAnswer(
        (_) async => const Right(null),
      );
      final result = await useCase('email');
      expect(
        result,
        equals(
          const Right<dynamic, void>(null),
        ),
      );
      verify(() => repo.forgotPassword('email')).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
