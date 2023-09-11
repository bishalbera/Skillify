import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/common/app/providers/bottom_navigator.dart';

class PersistentView extends StatefulWidget {
  const PersistentView({super.key, this.body});

  final Widget? body;

  @override
  State<PersistentView> createState() => _PersistentViewState();
}

class _PersistentViewState extends State<PersistentView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ?? context.watch<BottomNavigator>().currentPage.child;
  }

  @override
  bool get wantKeepAlive => true;
}
