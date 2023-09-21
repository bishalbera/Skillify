import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/core/enums/update_user.dart';
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';
import 'package:skillify/src/auth/data/repos/auth_repo_impl.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource remoteDataSource;
  late AuthRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImpl(remoteDataSource);
    registerFallbackValue(UpdateUserAction.password);
  });

  const tPassword = 'Test password';
  const tName = 'Test  name';
  const tEmail = 'Test email';
  const tUpdateAction = UpdateUserAction.password;
  const tUserData = 'New password';

  const tUser = LocalUserModel.empty();

  group(
    'forgotPassword',
    () {
      test(
        'should return [void] when call to remote source is successful',
        () async {
          when(() => remoteDataSource.forgotPassword(any())).thenAnswer(
            (_) async => const Right<dynamic, void>(null),
          );
          final result = await repoImpl.forgotPassword(tEmail);
          expect(
            result,
            equals(const Right<dynamic, void>(null)),
          );
          verify(() => remoteDataSource.forgotPassword(tEmail)).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
        ' should return [ServerFailure] when call to remote source is '
        'unsuccessful',
        () async {
          when(() => remoteDataSource.forgotPassword(any())).thenThrow(
            const ServerException(
              message: 'user does not exist',
              statusCode: 404,
            ),
          );
          final result = await repoImpl.forgotPassword(tEmail);
          expect(
            result,
            equals(
              Left<dynamic, void>(
                ServerFailure(
                  message: 'user does not exist',
                  statusCode: 404,
                ),
              ),
            ),
          );
          verify(() => remoteDataSource.forgotPassword(tEmail)).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );

  group(
    'signIn',
    () {
      test(
        'should return [LocalUser] when call to remote source is successful',
        () async {
          when(() => remoteDataSource.signIn(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),).thenAnswer(
            (_) async => tUser,
          );
          final result = await repoImpl.signIn(
            email: tEmail,
            password: tPassword,
          );
          expect(
            result,
            equals(
              const Right<dynamic, LocalUser>(
                tUser,
              ),
            ),
          );
          verify(
            () => remoteDataSource.signIn(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );

  group(
    'signUp',
    () {
      test(
        'should return [void] when call to remote source is successful',
        () async {
          when(
            () => remoteDataSource.signUp(
              email: any(named: 'email'),
              name: any(named: 'name'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => const Right<dynamic, void>(null),
          );
          final result = await repoImpl.signUp(
            email: tEmail,
            name: tName,
            password: tPassword,
          );
          expect(
            result,
            equals(
              const Right<dynamic, void>(
                null,
              ),
            ),
          );
          verify(
            () => remoteDataSource.signUp(
              email: tEmail,
              name: tName,
              password: tPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
        ' should return [ServerFailure] when call to remote source is '
        'unsuccessful',
        () async {
          when(
            () => remoteDataSource.signUp(
              email: any(named: 'email'),
              name: any(named: 'name'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            const ServerException(
              message: 'user already exists',
              statusCode: 400,
            ),
          );
          final result = await repoImpl.signUp(
            email: tEmail,
            name: tName,
            password: tPassword,
          );
          expect(
            result,
            equals(
              Left<dynamic, void>(
                ServerFailure(
                  message: 'user already exists',
                  statusCode: 400,
                ),
              ),
            ),
          );
          verify(
            () => remoteDataSource.signUp(
              email: tEmail,
              name: tName,
              password: tPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );

  group(
    'updateUser',
    () {
      test(
        'should return [void] when call to remote source is successful',
        () async {
          when(
            () => remoteDataSource.updateUser(
              action: any(named: 'action'),
              userData: any<dynamic>(named: 'userData'),
            ),
          ).thenAnswer(
            (_) async => const Right<dynamic, void>(null),
          );
          final result = await repoImpl.updateUser(
            action: tUpdateAction,
            userData: tUserData,
          );
          expect(
            result,
            equals(const Right<dynamic, void>(null)),
          );
          verify(
            () => remoteDataSource.updateUser(
              action: tUpdateAction,
              userData: tUserData,
            ),
          ).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
        'should return [ServerFailure] when call to remote source is '
        'unsuccessful',
        () async {
          when(
            () => remoteDataSource.updateUser(
              action: any(named: 'action'),
              userData: any<dynamic>(named: 'userData'),
            ),
          ).thenThrow(
            const ServerException(
              message: 'user does not exist',
              statusCode: 404,
            ),
          );
          final result = await repoImpl.updateUser(
            action: tUpdateAction,
            userData: tUserData,
          );
          expect(
            result,
            equals(
              Left<dynamic, void>(
                ServerFailure(
                  message: 'user does not exist',
                  statusCode: 404,
                ),
              ),
            ),
          );
          verify(
            () => remoteDataSource.updateUser(
              action: tUpdateAction,
              userData: tUserData,
            ),
          ).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );
}
