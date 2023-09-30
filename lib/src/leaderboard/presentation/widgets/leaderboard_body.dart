import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/common/views/loading_view.dart';
import 'package:skillify/core/common/widgets/not_found_text.dart';
import 'package:skillify/core/res/media_res.dart';
import 'package:skillify/core/utils/constants.dart';
import 'package:skillify/core/utils/core_utils.dart';
import 'package:skillify/src/auth/domain/entities/user.dart';
import 'package:skillify/src/leaderboard/presentation/cubit/leaderboard_cubit.dart';

class LeaderboardBody extends StatefulWidget {
  const LeaderboardBody({super.key});

  @override
  State<LeaderboardBody> createState() => _LeaderboardBodyState();
}

class _LeaderboardBodyState extends State<LeaderboardBody> {
  void getTopLearners() {
    context.read<LeaderboardCubit>().getTopLearners();
  }

  @override
  void initState() {
    super.initState();
    getTopLearners();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaderboardCubit, LeaderboardState>(
      listener: (_, state) {
        if (state is LeaderboardError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is LoadingLeaderboard) {
          return const LoadingView();
        } else if (state is LeaderboardLoaded && state.users.isEmpty) {
          return const NotFoundText(
            'Give exams and score well to get a chance to be in the top leaderboard',
          );
        } else if (state is LeaderboardLoaded) {
          final users = state.users;

          users.sort((a, b) => b.points.compareTo(a.points));

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // List of users
                    ListView.builder(
                      padding:
                          EdgeInsets.only(top: users.length >= 3 ? 200.0 : 0.0),
                      itemCount: users.length,
                      itemBuilder: (_, index) {
                        final user = users[index];
                        final rank = index + 1;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 5,
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$rank',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(user.profilePic!),
                                ),
                              ],
                            ),
                            title: Text(
                              user.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text('Points: ${user.points}'),
                          ),
                        );
                      },
                    ),

                    if (users.length >= 3)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWinner(users[0], 1),
                            _buildWinner(users[1], 2),
                            _buildWinner(users[2], 3),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Helper function to build a winner's widget
  Widget _buildWinner(LocalUser user, int rank) {
    return Flexible(
      child: Column(
        children: [
          if (rank == 1)
            Image.asset(
              MediaRes.goldCrown,
              width: 50,
              height: 50,
            ),
          if (rank == 2)
            Image.asset(
              MediaRes.silverMedal,
              width: 50,
              height: 50,
            ),
          if (rank == 3)
            Image.asset(
              MediaRes.bronzeMedal,
              width: 50,
              height: 50,
            ),
          CircleAvatar(
            radius: 40,
            backgroundImage: user.profilePic != null
                ? NetworkImage(user.profilePic!)
                : const NetworkImage(kDefaultAvatar) as ImageProvider,
          ),
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
