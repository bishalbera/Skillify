import 'package:flutter/material.dart';
import 'package:skillify/core/common/widgets/gradient_background.dart';
import 'package:skillify/core/res/media_res.dart';
import 'package:skillify/src/home/presentation/widgets/home_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(),
      body: GradientBackground(
        child: HomeBody(),
        image: MediaRes.homeGradientBackground,
      ),
    );
  }
}
