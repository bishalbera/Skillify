import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skillify/core/res/media_res.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MediaRes.onBoardingBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Lottie.asset(MediaRes.pageUnderConstruction),
          ),
        ),
      ),
    );
  }
}
