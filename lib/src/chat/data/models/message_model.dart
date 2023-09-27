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
          senderId: map['senderid'] as String,
          message: map['message'] as String,
          groupId: map['groupid'] as String,
          timestamp: DateTime.parse(map['lastMessageTimeStamp'] as String),
        );

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
