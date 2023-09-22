import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skillify/core/errors/failures.dart';

import 'package:skillify/src/notification/domain/entities/notification.dart';
import 'package:skillify/src/notification/domain/usecases/clear.dart';
import 'package:skillify/src/notification/domain/usecases/clear_all.dart';
import 'package:skillify/src/notification/domain/usecases/get_notification.dart';
import 'package:skillify/src/notification/domain/usecases/mark_as_read.dart';
import 'package:skillify/src/notification/domain/usecases/send_notification.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required Clear clear,
    required ClearAll clearAll,
    required GetNotifications getNotifications,
    required MarkAsRead markAsRead,
    required SendNotification sendNotification,
  })  : _clear = clear,
        _clearAll = clearAll,
        _getNotifications = getNotifications,
        _markAsRead = markAsRead,
        _sendNotification = sendNotification,
        super(const NotificationInitial());

  final Clear _clear;
  final ClearAll _clearAll;
  final GetNotifications _getNotifications;
  final MarkAsRead _markAsRead;
  final SendNotification _sendNotification;

  Future<void> clear(String notificationId) async {
    emit(const ClearingNotifications());
    final result = await _clear(notificationId);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationCleared()),
    );
  }

  Future<void> clearAll() async {
    emit(const ClearingNotifications());
    final result = await _clearAll();
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationCleared()),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _markAsRead(notificationId);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationInitial()),
    );
  }

  Future<void> sendNotification(Notification notification) async {
    emit(const SendingNotification());
    final result = await _sendNotification(notification);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationCleared()),
    );
  }

  void getNotifications() {
    emit(const GettingNotifications());
    StreamSubscription<Either<Failure, List<Notification>>>? subscription;

    subscription = _getNotifications().listen(
      /*onData:*/
      (result) {
        result.fold(
          (failure) {
            emit(NotificationError(failure.errorMessage));
            subscription?.cancel();
          },
          (notifications) => emit(NotificationsLoaded(notifications)),
        );
      },
      onError: (dynamic error) {
        emit(NotificationError(error.toString()));
        subscription?.cancel();
      },
      onDone: () {
        subscription?.cancel();
      },
    );
  }
}
