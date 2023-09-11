import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/common/app/providers/bottom_navigator.dart';
import 'package:skillify/core/common/app/providers/user_provider.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;

  BottomNavigator get bottomNavigator => read<BottomNavigator>();

  void pop() => bottomNavigator.pop();

  void push(Widget page) => bottomNavigator.push(BottomItem(child: page));
}
