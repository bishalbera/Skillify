import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/common/views/loading_view.dart';
import 'package:skillify/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        builder: (context, state) {
          if (state is CheckingIfUserIsFirstTimer) {
            return const LoadingView();
          }
        },
        listener: (context, state) {
          if (state is OnBoardingStatus) {}
        },
      ),
    );
  }
}
