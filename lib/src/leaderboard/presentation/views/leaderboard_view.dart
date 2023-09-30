import 'package:flutter/material.dart';
import 'package:skillify/core/common/widgets/gradient_background.dart';
import 'package:skillify/core/res/media_res.dart';
import 'package:skillify/src/leaderboard/presentation/widgets/leaderboard_app_bar.dart';
import 'package:skillify/src/leaderboard/presentation/widgets/leaderboard_body.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const LeaderboardAppbar(),
      body: GradientBackground(
        image: MediaRes.leaderboardGradientBackground,
        child: Container(
          child: const LeaderboardBody(),
        ),
      ),
    );
  }
}
