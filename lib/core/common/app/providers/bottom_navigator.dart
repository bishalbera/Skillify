import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BottomNavigator extends ChangeNotifier {
  BottomNavigator(this._initialPage) {
    _navigationStack.add(_initialPage);
  }
  final BottomItem _initialPage;

  final List<BottomItem> _navigationStack = [];

  BottomItem get currentPage => _navigationStack.last;

  void push(BottomItem page) {
    _navigationStack.add(page);
    notifyListeners();
  }

  void pop() {
    if (_navigationStack.length > 1) _navigationStack.removeLast();
    notifyListeners();
  }

  void popToRoot() {
    _navigationStack
      ..clear()
      ..add(_initialPage);
    notifyListeners();
  }

  void popTo(BottomItem page) {
    _navigationStack.remove(page);
    notifyListeners();
  }

  void popUntil(BottomItem? page) {
    if (page == null) return popToRoot();
    if (_navigationStack.length > 1) {
      _navigationStack.removeRange(1, _navigationStack.indexOf(page) + 1);
      notifyListeners();
    }
  }

  void pushAndRemoveUntill(BottomItem page) {
    _navigationStack
      ..clear()
      ..add(page);
    notifyListeners();
  }
}

class BottomNavigatorProvider extends InheritedNotifier<BottomNavigator> {
  const BottomNavigatorProvider({
    required this.navigator,
    required super.child,
    super.key,
  }) : super(notifier: navigator);

  final BottomNavigator navigator;

  static BottomNavigator? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BottomNavigatorProvider>()
        ?.navigator;
  }
}

class BottomItem extends Equatable {
  BottomItem({required this.child}) : id = const Uuid().v1();

  final Widget child;
  final String id;

  @override
  List<dynamic> get props => [id];
}
