import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/utils/core_utils.dart';
import 'package:skillify/src/notification/presentation/cubit/notification_cubit.dart';

class NotificationWrapper extends StatefulWidget {
  const NotificationWrapper({
    required this.onNotificationSent,
    required this.child,
    super.key,
    this.extraActivity,
  });

  final Widget child;
  final VoidCallback? extraActivity;
  final VoidCallback onNotificationSent;

  @override
  State<NotificationWrapper> createState() => _NotificationWrapperState();
}

class _NotificationWrapperState extends State<NotificationWrapper> {
  bool showingLoader = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (showingLoader) {
          Navigator.pop(context);
          showingLoader = false;
        }
        if (state is NotificationCleared) {
          widget.extraActivity?.call();
          widget.onNotificationSent();
        } else if (state is SendingNotification) {
          showingLoader = true;
          CoreUtils.showLoadingDialog(context);
        }
      },
      child: widget.child,
    );
  }
}
