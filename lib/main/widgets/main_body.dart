import 'package:flutter/material.dart';
import 'package:road_guard/main/cubit/cubit.dart';

/// {@template main_body}
/// Body of the MainPage.
///
/// Add what it does
/// {@endtemplate}
class MainBody extends StatelessWidget {
  /// {@macro main_body}
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Center(child: Text(state.customProperty));
      },
    );
  }
}
