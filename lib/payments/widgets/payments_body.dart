import 'package:flutter/material.dart';
import 'package:road_guard/payments/cubit/cubit.dart';

/// {@template payments_body}
/// Body of the PaymentsPage.
///
/// Add what it does
/// {@endtemplate}
class PaymentsBody extends StatelessWidget {
  /// {@macro payments_body}
  const PaymentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsCubit, PaymentsState>(
      builder: (context, state) {
        return Center(child: Text(state.message));
      },
    );
  }
}
