import 'package:flutter/material.dart';
import 'package:road_guard/start/cubit/cubit.dart';
import 'package:road_guard/widgets/loading_screen.dart';

/// {@template start_body}
/// Body of the StartPage.
///
/// Add what it does
/// {@endtemplate}
class StartBody extends StatelessWidget {
  /// {@macro start_body}
  const StartBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartCubit, StartState>(
      builder: (context, state) {
        return const LoadingScreen();
      },
    );
  }
}
