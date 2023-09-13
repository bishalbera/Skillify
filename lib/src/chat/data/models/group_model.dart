import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/chat/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.courseId,
    required super.members,
    super.lastMessage,
    super.groupImageUrl,
    super.lastMessageTimeStamp,
    super.lastMessageSenderName,
  });

  GroupModel.empty()
      : this(
          id: '',
          name: '',
          courseId: '',
          members: const [],
          lastMessage: '',
          groupImageUrl: '',
          lastMessageTimeStamp: DateTime.now(),
          lastMessageSenderName: '',
        );

  GroupModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          courseId: map['courseId'] as String,
          members: List<String>.from(map['members'] as List<dynamic>),
          lastMessage: map['lastMessage'] as String?,
          groupImageUrl: map['groupImageUrl'] as String?,
          lastMessageSenderName: map['lastMessageSenderName'] as String?,
          lastMessageTimeStamp:
              DateTime.parse(map['lastMessageTimeStamp'] as String),
        );

  GroupModel copyWith({
    String? id,
    String? name,
    String? courseId,
    List<String>? members,
    String? lastMessage,
    String? groupImageUrl,
    DateTime? lastMessageTimeStamp,
    String? lastMessageSenderName,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
      lastMessageTimeStamp: lastMessageTimeStamp ?? this.lastMessageTimeStamp,
      lastMessageSenderName:
          lastMessageSenderName ?? this.lastMessageSenderName,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'courseId': courseId,
      'members': members,
      'lastMessage': lastMessage,
      'groupImageUrl': groupImageUrl,
      'lastMessageTimeStamp':
          lastMessage == null ? null : DateTime.now().toUtc().toIso8601String(),
      'lastMessageSenderName': lastMessageSenderName,
    };
  }
}
