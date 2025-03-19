import 'package:flutter/material.dart';
import 'package:road_guard/main/cubit/cubit.dart';
import 'package:road_guard/main/widgets/main_body.dart';

/// {@template main_page}
/// A description for MainPage
/// {@endtemplate}
class MainPage extends StatelessWidget {
  /// {@macro main_page}
  const MainPage({super.key});

  /// The static route for MainPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const MainPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(context.read()),
      child: const Scaffold(
        body: MainView(),
      ),
    );
  }
}

/// {@template main_view}
/// Displays the Body of MainView
/// {@endtemplate}
class MainView extends StatelessWidget {
  /// {@macro main_view}
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainBody();
  }
}
