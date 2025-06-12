import 'package:flutter/material.dart';
import 'package:road_guard/auth/auth_bloc.dart';
import 'package:road_guard/road_tax/cubit/cubit.dart';
import 'package:road_guard/road_tax/widgets/road_tax_body.dart';

/// {@template road_tax_page}
/// A description for RoadTaxPage
/// {@endtemplate}
class RoadTaxPage extends StatelessWidget {
  /// {@macro road_tax_page}
  const RoadTaxPage({super.key});

  /// The static route for RoadTaxPage

  static Route<dynamic> route(String action) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const RoadTaxPage(),
      settings: RouteSettings(arguments: action),
    );
  }

  @override
  Widget build(BuildContext context) {
    final action =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'View';
    return BlocProvider(
      create: (context) => RoadTaxCubit(context.read())..updateAction(action),
      child: const Scaffold(
        body: RoadTaxView(),
      ),
    );
  }
}

/// {@template road_tax_view}
/// Displays the Body of RoadTaxView
/// {@endtemplate}
class RoadTaxView extends StatelessWidget {
  /// {@macro road_tax_view}
  const RoadTaxView({super.key});

  @override
  Widget build(BuildContext context) {
    final action =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'View';
    final user = context.watch<AuthBloc>().state.user;
    if (action != 'Add') {
      context.read<RoadTaxCubit>().getDriversLicenses(user.email!);
    }
    // return const RoadTaxBody();
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<RoadTaxCubit, RoadTaxState>(
          builder: (context, state) {
            return Text(state.title);
          },
        ),
      ),
      body: const RoadTaxBody(),
    );
  }
}
