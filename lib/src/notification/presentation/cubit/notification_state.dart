part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class GettingNotifications extends NotificationState {
  const GettingNotifications();
}

class SendingNotification extends NotificationState {
  const SendingNotification();
}

class ClearingNotifications extends NotificationState {
  const ClearingNotifications();
}

class NotificationSent extends NotificationState {
  const NotificationSent();
}

class NotificationCleared extends NotificationState {
  const NotificationCleared();
}

class NotificationsLoaded extends NotificationState {
  const NotificationsLoaded(this.notifications);

  final List<Notification> notifications;

  @override
  List<Object> get props => notifications;
}

class NotificationError extends NotificationState {
  const NotificationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
