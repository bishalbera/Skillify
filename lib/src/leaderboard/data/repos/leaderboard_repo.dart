import 'package:dartz/dartz.dart';
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/errors/failures.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/leaderboard/data/datasources/leaderboard_remote_data_src.dart';
import 'package:skillify/src/leaderboard/domain/repos/leaderboard_repo.dart';

class LeaderboardRepoImpl implements LeaderboardRepo {
  const LeaderboardRepoImpl(this._remoteDataSource);

  final LeaderboardRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<LocalUser>> getTopLearners() async {
    try {
      final topLearners = await _remoteDataSource.getTopLearners();
      return Right(topLearners);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
