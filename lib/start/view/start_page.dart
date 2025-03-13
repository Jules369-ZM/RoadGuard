import 'package:flutter/material.dart';
import 'package:road_guard/start/cubit/cubit.dart';
import 'package:road_guard/start/widgets/start_body.dart';

/// {@template start_page}
/// A description for StartPage
/// {@endtemplate}
class StartPage extends StatelessWidget {
  /// {@macro start_page}
  const StartPage({super.key});

  /// The static route for StartPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const StartPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartCubit(),
      child: const Scaffold(
        body: StartView(),
      ),
    );
  }    
}

/// {@template start_view}
/// Displays the Body of StartView
/// {@endtemplate}
class StartView extends StatelessWidget {
  /// {@macro start_view}
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartBody();
  }
}
