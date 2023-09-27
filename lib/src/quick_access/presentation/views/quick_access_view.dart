import 'package:flutter/material.dart';
import 'package:skillify/core/common/widgets/gradient_background.dart';
import 'package:skillify/core/res/media_res.dart';
import 'package:skillify/src/quick_access/presentation/widgets/quick_access_app_bar.dart';
import 'package:skillify/src/quick_access/presentation/widgets/quick_access_header.dart';
import 'package:skillify/src/quick_access/presentation/widgets/quick_access_tab_bar.dart';
import 'package:skillify/src/quick_access/presentation/widgets/quick_access_tab_body.dart';

class QuickAccessView extends StatelessWidget {
  const QuickAccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: QuickAccessAppBar(),
      body: GradientBackground(
        image: MediaRes.documentsGradientBackground,
        child: Center(
          child: Column(
            children: [
              Expanded(flex: 2, child: QuickAccessHeader()),
              Expanded(child: QuickAccessTabBar()),
              Expanded(flex: 2, child: QuickAccessTabBody()),
            ],
          ),
        ),
      ),
    );
  }
}
