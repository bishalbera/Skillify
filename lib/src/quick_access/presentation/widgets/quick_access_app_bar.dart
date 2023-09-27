import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillify/core/common/app/providers/user_provider.dart';
import 'package:skillify/core/res/media_res.dart';

class QuickAccessAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuickAccessAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Materials'),
      centerTitle: false,
      actions: [
        Consumer<UserProvider>(
          builder: (_, provider, __) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 24,
                backgroundImage: provider.user!.profilePic != null
                    ? NetworkImage(provider.user!.profilePic!)
                    : const AssetImage(MediaRes.user) as ImageProvider,
              ),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
