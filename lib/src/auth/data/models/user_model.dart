import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.points,
    super.groupIds,
    super.enrolledCourseIds,
    super.following,
    super.followers,
    super.profilePic,
    super.bio,
  });

  const LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          name: '',
          points: 0,
        );

  LocalUserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          email: map['email'] as String,
          name: map['name'] as String,
          profilePic: map['profilePic'] as String?,
          bio: map['bio'] as String?,
          points: map['points'] as int,
          groupIds: (map['groupIds'] as List<dynamic>).cast<String>(),
          enrolledCourseIds:
              (map['enrolledCourseIds'] as List<dynamic>).cast<String>(),
          following: (map['following'] as List<dynamic>).cast<String>(),
          followers: (map['followers'] as List<dynamic>).cast<String>(),
        );

  LocalUser copyWith({
    String? uid,
    String? email,
    String? name,
    String? profilePic,
    String? bio,
    int? points,
    List<String>? groupIds,
    List<String>? enrolledCourseIds,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      groupIds: groupIds ?? this.groupIds,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'bio': bio,
      'points': points,
      'groupIds': groupIds,
      'enrolledCourseIds': enrolledCourseIds,
      'following': following,
      'followers': followers,
    };
  }
}
