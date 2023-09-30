part of 'leaderboard_cubit.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();
  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {
  const LeaderboardInitial();
}

class LoadingLeaderboard extends LeaderboardState {
  const LoadingLeaderboard();
}

class LeaderboardLoaded extends LeaderboardState {
  const LeaderboardLoaded(this.users);

  final List<LocalUser> users;

  @override
  List<Object> get props => [users];
}

class LeaderboardError extends LeaderboardState {
  const LeaderboardError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
