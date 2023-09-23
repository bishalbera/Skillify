part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          } else if (sl<SupabaseClient>().auth.currentUser != null) {
            final user = sl<SupabaseClient>().auth.currentUser!;
            final localUser = LocalUserModel(
              id: user.id,
              email: user.email ?? '',
              name: user.appMetadata['name'].toString() ?? '',
              points: 0,
            );
            context.userProvider.initUser(localUser);
            return const Dashboard();
          }
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: settings,
      );
    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case Dashboard.routeName:
      return _pageBuilder(
        (_) => const Dashboard(),
        settings: settings,
      );
    case '/forgot-password':
      return _pageBuilder(
        (context) => SupaResetPassword(
          accessToken: sl<SupabaseClient>().auth.currentSession?.accessToken,
          onSuccess: (UserResponse response) {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        settings: settings,
      );
    case CourseDetailsScreen.routeName:
      return _pageBuilder(
        (_) => CourseDetailsScreen(settings.arguments! as Course),
        settings: settings,
      );
    case AddVideoView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<CourseCubit>()),
            BlocProvider(create: (_) => sl<VideoCubit>()),
            BlocProvider(create: (_) => sl<NotificationCubit>()),
          ],
          child: const AddVideoView(),
        ),
        settings: settings,
      );
    case AddMaterialsView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<CourseCubit>()),
            BlocProvider(create: (_) => sl<MaterialCubit>()),
            BlocProvider(create: (_) => sl<NotificationCubit>()),
          ],
          child: const AddMaterialsView(),
        ),
        settings: settings,
      );
    case AddExamView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<CourseCubit>()),
            BlocProvider(create: (_) => sl<ExamCubit>()),
            BlocProvider(create: (_) => sl<NotificationCubit>()),
          ],
          child: const AddExamView(),
        ),
        settings: settings,
      );
    case VideoPlayerView.routeName:
      return _pageBuilder(
        (_) => VideoPlayerView(videoURL: settings.arguments! as String),
        settings: settings,
      );
    case CourseVideosView.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<VideoCubit>(),
          child: CourseVideosView(settings.arguments! as Course),
        ),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
