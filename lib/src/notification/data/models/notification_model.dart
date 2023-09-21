import 'package:skillify/core/enums/notification_enum.dart';
import 'package:skillify/core/extensions/enum_extensions.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/notification/domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.category,
    required super.sentAt,
    super.seen,
  });

  NotificationModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String,
          body: map['body'] as String,
          category: (map['category'] as String).toNotificationCategory,
          seen: map['seen'] as bool,
          sentAt: DateTime.parse(map['sentAt'] as String) ?? DateTime.now(),
        );

  NotificationModel.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          body: '_empty.body',
          category: NotificationCategory.NONE,
          seen: false,
          sentAt: DateTime.now(),
        );

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationCategory? category,
    bool? seen,
    DateTime? sentAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      seen: seen ?? this.seen,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  DataMap toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'category': category.value,
        'seen': seen,
        'sentAt': DateTime.now().toUtc().toIso8601String(),
      };
}
