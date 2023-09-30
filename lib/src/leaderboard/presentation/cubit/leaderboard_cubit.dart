import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/leaderboard/domain/usecases/get_top_learners.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit({required GetTopLearners getTopLearners})
      : _getTopLearners = getTopLearners,
        super(const LeaderboardInitial());

  final GetTopLearners _getTopLearners;

  Future<void> getTopLearners() async {
    emit(const LoadingLeaderboard());
    final result = await _getTopLearners();
    result.fold(
      (failure) => emit(LeaderboardError(failure.errorMessage)),
      (topUsers) => emit(LeaderboardLoaded(topUsers)),
    );
  }
}
