import 'package:flutter/material.dart';
import 'package:road_guard/payments/cubit/cubit.dart';
import 'package:road_guard/payments/widgets/payments_body.dart';

/// {@template payments_page}
/// A description for PaymentsPage
/// {@endtemplate}
class PaymentsPage extends StatelessWidget {
  /// {@macro payments_page}
  const PaymentsPage({super.key});

  /// The static route for PaymentsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const PaymentsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentsCubit(),
      child: const Scaffold(
        body: PaymentsView(),
      ),
    );
  }    
}

/// {@template payments_view}
/// Displays the Body of PaymentsView
/// {@endtemplate}
class PaymentsView extends StatelessWidget {
  /// {@macro payments_view}
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaymentsBody();
  }
}
