import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';
import 'package:skillify/src/auth/domain/usecases/forgot_password.dart';
import 'package:skillify/src/auth/domain/usecases/sign_in.dart';
import 'package:skillify/src/auth/domain/usecases/sign_up.dart';
import 'package:skillify/src/auth/domain/usecases/update_user.dart';
import 'package:skillify/src/auth/presentation/bloc/auth_bloc.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tSignInParams = SignInParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

  setUp(
    () {
      signIn = MockSignIn();
      signUp = MockSignUp();
      forgotPassword = MockForgotPassword();
      updateUser = MockUpdateUser();
      authBloc = AuthBloc(
        signIn: signIn,
        signUp: signUp,
        forgotPassword: forgotPassword,
        updateUser: updateUser,
      );
    },
  );

  setUpAll(
    () {
      registerFallbackValue(tSignInParams);
      registerFallbackValue(tSignUpParams);
      registerFallbackValue(tUpdateUserParams);
    },
  );

  tearDown(() => authBloc.close());

  test(
    'initialState should be [AuthInitial]',
    () {
      expect(authBloc.state, const AuthInitial());
    },
  );

  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  group(
    'SignInEvent',
    () {
      const tUser = LocalUserModel.empty();
      blocTest<AuthBloc, AuthState>(
        ' should emit [AuthLoading, SignedIn] when '
        'signIn succeeds',
        build: () {
          when(() => signIn(any())).thenAnswer((_) async => const Right(tUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignInEvent(
            email: tSignInParams.email,
            password: tSignInParams.password,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const SignedIn(tUser),
        ],
        verify: (_) {
          verify(() => signIn(tSignInParams)).called(1);
          verifyNoMoreInteractions(signIn);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when signIn fails',
        build: () {
          when(() => signIn(any()))
              .thenAnswer((_) async => Left(tServerFailure));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignInEvent(
            email: tSignInParams.email,
            password: tSignInParams.password,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          AuthError(tServerFailure.errorMessage),
        ],
        verify: (_) {
          verify(() => signIn(tSignInParams)).called(1);
          verifyNoMoreInteractions(signIn);
        },
      );
    },
  );

  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] when SignUpEvent is added '
      'and SignUp succeeds',
      build: () {
        when(() => signUp(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.name,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const SignedUp(),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when SignUpEvent is added and '
      'SignUp fails',
      build: () {
        when(() => signUp(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.name,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('ForgotPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, ForgotPasswordSent] when ForgotPasswordEvent '
      'is added and ForgotPassword succeeds',
      build: () {
        when(() => forgotPassword(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
      expect: () => [
        const AuthLoading(),
        const ForgotPasswordSent(),
      ],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when ForgotPasswordEvent is added '
      'and ForgotPassword fails',
      build: () {
        when(() => forgotPassword(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('UpdateUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserUpdated] when UpdateUserEvent is added '
      'and UpdateUser succeeds',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const UserUpdated(),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when UpdateUserEvent is added and '
      'UpdateUser fails',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
