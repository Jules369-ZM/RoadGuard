import 'package:flutter/material.dart';
import 'package:road_guard/sign_up/cubit/cubit.dart';
import 'package:road_guard/sign_up/widgets/sign_up_body.dart';

/// {@template sign_up_page}
/// A description for SignUpPage
/// {@endtemplate}
class SignUpPage extends StatelessWidget {
  /// {@macro sign_up_page}
  const SignUpPage({super.key});

  /// The static route for SignUpPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(context.read()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign Up')),
        body: const SignUpView(),
      ),
    );
  }
}

/// {@template sign_up_view}
/// Displays the Body of SignUpView
/// {@endtemplate}
class SignUpView extends StatelessWidget {
  /// {@macro sign_up_view}
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpBody();
  }
}
