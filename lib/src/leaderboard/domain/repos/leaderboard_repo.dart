import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';

abstract class LeaderboardRepo {
  const LeaderboardRepo();

  ResultFuture<List<LocalUser>> getTopLearners();
}
