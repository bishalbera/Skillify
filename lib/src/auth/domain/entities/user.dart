import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.id,
    required this.email,
    required this.name,
    required this.points,
    this.groupIds = const [],
    this.enrolledCourseIds = const [],
    this.following = const [],
    this.followers = const [],
    this.profilePic,
    this.bio,
  });

  const LocalUser.empty()
      : this(
          id: '',
          email: '',
          points: 0,
          name: '',
          profilePic: '',
          bio: '',
          groupIds: const [],
          enrolledCourseIds: const [],
          followers: const [],
          following: const [],
        );

  final String id;
  final String email;
  final String name;
  final String? profilePic;
  final String? bio;
  final int points;
  final List<String> groupIds;
  final List<String> enrolledCourseIds;
  final List<String> following;
  final List<String> followers;

  @override
  List<Object?> get props => [id, email];

  @override
  String toString() {
    return ' LocalUser(id: $id, email: $email, name: $name, '
        'bio: $bio, points: $points,)';
  }
}
