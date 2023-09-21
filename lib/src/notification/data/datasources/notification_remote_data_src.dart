import 'package:skillify/src/notification/data/models/notification_model.dart';
import 'package:skillify/src/notification/domain/entities/notification.dart';

abstract class NotificationRemoteDataSrc {
  const NotificationRemoteDataSrc();

  Future<void> markAsRead(String notificationId);

  Future<void> clearAll();

  Future<void> clear(String notificationId);

  Future<void> sendNotification(Notification notification);

  Stream<List<NotificationModel>> getNotifications();
}
