import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:skillify/core/extensions/context_extension.dart';
import 'package:skillify/core/res/fonts.dart';
import 'package:skillify/src/on_boarding/domain/entities/page_content.dart';
import 'package:skillify/src/on_boarding/presentation/widgets/animated_button.dart';

class OnBoardingBody extends StatefulWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;

  @override
  State<OnBoardingBody> createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<OnBoardingBody> {
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      'active',
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          width: context.width * 1.7,
          bottom: 200,
          left: 100,
          child: Image.asset(widget.pageContent.image),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          ),
        ),
        RiveAnimation.asset(widget.pageContent.animation),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const SizedBox(),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 240),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 260,
                    child: Column(
                      children: [
                        Text(
                          widget.pageContent.title,
                          style: const TextStyle(
                            fontSize: 45,
                            fontFamily: Fonts.poppins,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.pageContent.description,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AnimatedBtn(
                        btnAnimationController: _btnAnimationController,
                        press: () {
                          _btnAnimationController.isActive = true;
                        },
                        text: 'Get Started',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
