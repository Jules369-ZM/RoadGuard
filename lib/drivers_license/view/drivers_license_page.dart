import 'package:flutter/material.dart';
import 'package:road_guard/drivers_license/cubit/cubit.dart';
import 'package:road_guard/drivers_license/widgets/drivers_license_body.dart';

/// {@template drivers_license_page}
/// A description for DriversLicensePage
/// {@endtemplate}
class DriversLicensePage extends StatelessWidget {
  /// {@macro drivers_license_page}
  const DriversLicensePage({super.key});

  /// The static route for DriversLicensePage
  static Route<dynamic> route(String action) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const DriversLicensePage(),
      settings: RouteSettings(arguments: action),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriversLicenseCubit(context.read()),
      child: const DriversLicenseView(),
    );
  }
}

/// {@template drivers_license_view}
/// Displays the Body of DriversLicenseView
/// {@endtemplate}
class DriversLicenseView extends StatelessWidget {
  /// {@macro drivers_license_view}
  const DriversLicenseView({super.key});

  @override
  Widget build(BuildContext context) {
    final action = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    context.read<DriversLicenseCubit>().updateAction(action);
    return Scaffold(
      appBar: AppBar(title: Text('$action License')),
      body: const DriversLicenseBody(),
    );
  }
}
