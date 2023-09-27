import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:skillify/core/common/app/providers/bottom_navigator.dart';
import 'package:skillify/core/common/views/persistent_view.dart';
import 'package:skillify/core/services/injection_container.dart';
import 'package:skillify/src/course/features/videos/presentation/cubit/video_cubit.dart';

import 'package:skillify/src/course/presentation/cubit/course_cubit.dart';
import 'package:skillify/src/home/presentation/views/home_view.dart';
import 'package:skillify/src/notification/presentation/cubit/notification_cubit.dart';
import 'package:skillify/src/profile/presentation/views/profile_view.dart';
import 'package:skillify/src/quick_access/presentation/providers/quick_access_tab_controller.dart';
import 'package:skillify/src/quick_access/presentation/views/quick_access_view.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => BottomNavigator(
        BottomItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CourseCubit>()),
              BlocProvider(create: (_) => sl<VideoCubit>()),
              BlocProvider.value(value: sl<NotificationCubit>()),
            ],
            child: const HomeView(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => BottomNavigator(
        BottomItem(
          child: BlocProvider(
            create: (context) => sl<CourseCubit>(),
            child: ChangeNotifierProvider(
              create: (_) => QuickAccessTabController(),
              child: const QuickAccessView(),
            ),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => BottomNavigator(BottomItem(child: const Placeholder())),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => BottomNavigator(BottomItem(child: const ProfileView())),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;
  int _currentIndex = 3;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
