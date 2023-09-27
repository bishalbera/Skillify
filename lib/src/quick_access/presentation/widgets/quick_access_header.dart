import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillify/core/res/media_res.dart';
import 'package:skillify/src/quick_access/presentation/providers/quick_access_tab_controller.dart';

class QuickAccessHeader extends StatelessWidget {
  const QuickAccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuickAccessTabController>(
      builder: (_, controller, __) {
        return Center(
          child: Image.asset(
            controller.currentIndex == 0
                ? MediaRes.bluePotPlant
                : controller.currentIndex == 1
                    ? MediaRes.turquoisePotPlant
                    : MediaRes.steamCup,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
