import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.message,
    required super.timestamp,
    required super.groupId,
  });

  MessageModel.empty()
      : this(
          id: '',
          senderId: '',
          message: '',
          groupId: '',
          timestamp: DateTime.now(),
        );

  MessageModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          senderId: map['sender_id'] as String,
          message: map['message'] as String,
          groupId: map['group_id'] as String,
          timestamp: _parseDate(map['timestamp'] as String?),
        );

  static DateTime _parseDate(String? date) {
    try {
      return DateTime.parse(date!);
    } catch (e) {
      print('Invalid date format: $date');
      return DateTime.now(); // return current date as a fallback
    }
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? message,
    String? groupId,
    DateTime? timestamp,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      groupId: groupId ?? this.groupId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'message': message,
      'groupId': groupId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
