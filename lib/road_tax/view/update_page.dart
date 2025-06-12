import 'package:flutter/material.dart';
import 'package:road_guard/models/road_tax.dart';
import 'package:road_guard/road_tax/cubit/cubit.dart';
import 'package:road_guard/road_tax/widgets/update_tax.dart';

class UpdateRoadTaxPage extends StatelessWidget {
  const UpdateRoadTaxPage({super.key});

  /// The static route for UpdateDriverLicensePage
  static Route<dynamic> route(RoadTax tax) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const UpdateRoadTaxPage(),
      settings: RouteSettings(arguments: tax),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoadTaxCubit(context.read()),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Road Tax')),
      body: const UpdateTaxBody(),
    );
  }
}
