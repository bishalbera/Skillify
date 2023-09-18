import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillify/core/common/app/providers/user_provider.dart';
import 'package:skillify/core/extensions/context_extension.dart';
import 'package:skillify/src/home/presentation/widgets/tinder_cards.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Text(
            'Hello\n${context.watch<UserProvider>().user!.name}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36,
            ),
          ),
          Positioned(
            top: context.height >= 926
                ? -25
                : context.height >= 844
                    ? -6
                    : context.height <= 800
                        ? 10
                        : 10,
                        right: -14,
            child: const TinderCards(),
          ),
        ],
      ),
    );
  }
}
