import 'package:flutter/cupertino.dart';
import 'package:skillify/core/common/views/page_under_construction.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case OnBoardingScreen.routeName:
    //   return _pageBuilder(
    //     (_) => const OnBoardingScreen(),
    //     settings: settings,
    //   );
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
