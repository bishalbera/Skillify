import 'package:flutter/material.dart';

class LeaderboardAppbar extends StatelessWidget implements PreferredSizeWidget {
  const LeaderboardAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Leaderboard',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
