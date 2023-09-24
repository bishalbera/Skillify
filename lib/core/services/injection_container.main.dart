part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuth();
  await _initCourse();
  await _initVideo();
  await _initMaterial();
  await _initExam();
  await _initNotifications();
}

Future<void> _initNotifications() async {
  sl
    ..registerFactory(
      () => NotificationCubit(
        clear: sl(),
        clearAll: sl(),
        getNotifications: sl(),
        markAsRead: sl(),
        sendNotification: sl(),
      ),
    )
    ..registerLazySingleton(() => Clear(sl()))
    ..registerLazySingleton(() => ClearAll(sl()))
    ..registerLazySingleton(() => GetNotifications(sl()))
    ..registerLazySingleton(() => MarkAsRead(sl()))
    ..registerLazySingleton(() => SendNotification(sl()))
    ..registerLazySingleton<NotificationRepo>(() => NotificationRepoImpl(sl()))
    ..registerLazySingleton<NotificationRemoteDataSrc>(
      () => NotificationRemoteDataSrcImpl(client: sl()),
    );
}

Future<void> _initExam() async {
  sl
    ..registerFactory(
      () => ExamCubit(
        getExamQuestions: sl(),
        getExams: sl(),
        submitExam: sl(),
        updateExam: sl(),
        uploadExam: sl(),
        getUserCourseExams: sl(),
        getUserExams: sl(),
      ),
    )
    ..registerLazySingleton(() => GetExamQuestions(sl()))
    ..registerLazySingleton(() => GetExams(sl()))
    ..registerLazySingleton(() => SubmitExam(sl()))
    ..registerLazySingleton(() => UpdateExam(sl()))
    ..registerLazySingleton(() => UploadExam(sl()))
    ..registerLazySingleton(() => GetUserCourseExams(sl()))
    ..registerLazySingleton(() => GetUserExams(sl()))
    ..registerLazySingleton<ExamRepo>(() => ExamRepoImpl(sl()))
    ..registerLazySingleton<ExamRemoteDataSrc>(
      () => ExamRemoteDataSrcImpl(client: sl()),
    );
}

Future<void> _initMaterial() async {
  sl
    ..registerFactory(
      () => MaterialCubit(addMaterial: sl(), getMaterials: sl()),
    )
    ..registerLazySingleton(() => AddMaterial(sl()))
    ..registerLazySingleton(() => GetMaterials(sl()))
    ..registerLazySingleton<MaterialRepo>(() => MaterialRepoImpl(sl()))
    ..registerLazySingleton<MaterialRemoteDataSrc>(
      () => MaterialRemoteDataSrcImpl(client: sl(), dbClient: sl()),
    )
    ..registerFactory(() => ResourceController(dbClient: sl(), prefs: sl()));
}

Future<void> _initVideo() async {
  sl
    ..registerFactory(() => VideoCubit(addVideo: sl(), getVideos: sl()))
    ..registerLazySingleton(() => AddVideo(sl()))
    ..registerLazySingleton(() => GetVideos(sl()))
    ..registerLazySingleton<VideoRepo>(() => VideoRepoImpl(sl()))
    ..registerLazySingleton<VideoRemoteDataSrc>(
      () => VideoRemoteDataSrcImpl(client: sl(), dbClient: sl()),
    );
}

Future<void> _initCourse() async {
  sl
    ..registerFactory(
      () => CourseCubit(
        addCourse: sl(),
        getCourses: sl(),
      ),
    )
    ..registerLazySingleton(() => AddCourse(sl()))
    ..registerLazySingleton(() => GetCourses(sl()))
    ..registerLazySingleton<CourseRepo>(() => CourseRepoImpl(sl()))
    ..registerLazySingleton<CourseRemoteDataSrc>(
      () => CourseRemoteDataSrcImpl(
        client: sl(),
        dbClient: sl(),
      ),
    );
}

Future<void> _initAuth() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        client: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => Supabase.instance.client)
    ..registerLazySingleton(() => Supabase.instance.client.storage);
}

Future<void> _initOnBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(
      () => CacheFirstTimer(sl()),
    )
    ..registerLazySingleton(
      () => CheckIfUserIsFirstTimer(sl()),
    )
    ..registerLazySingleton<OnBoardingRepo>(
      () => OnBoardingRepoImpl(sl()),
    )
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSrcImpl(sl()),
    )
    ..registerLazySingleton(() => prefs);
}
