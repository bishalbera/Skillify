import 'package:equatable/equatable.dart';
import 'package:skillify/core/enums/notification_enum.dart';

class Notification extends Equatable {
  const Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.sentAt,
    required this.userId,
    this.seen = false,
  });

  Notification.empty()
      : id = '_empty.id',
        userId = '_empty.userId',
        title = '_empty.title',
        body = '_empty.body',
        category = NotificationCategory.NONE,
        seen = false,
        sentAt = DateTime.now();

  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationCategory category;
  final bool seen;
  final DateTime sentAt;

  @override
  List<Object?> get props => [id];
}
