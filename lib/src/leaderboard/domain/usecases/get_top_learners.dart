import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/leaderboard/domain/repos/leaderboard_repo.dart';

class GetTopLearners extends FutureUsecaseWithoutParams<List<LocalUser>> {
  const GetTopLearners(this._repo);

  final LeaderboardRepo _repo;
  @override
  ResultFuture<List<LocalUser>> call() => _repo.getTopLearners();
}
