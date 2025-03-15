import 'package:flutter/material.dart';
import 'package:road_guard/auth/auth.dart';
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
    final action = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    return BlocProvider(
      create: (context) =>
          DriversLicenseCubit(context.read())..updateAction(action),
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
    final user = context.watch<AuthBloc>().state.user;
    var title = '';
    if (action == 'Add') title = "Add Driver's License";
    if (action == 'View') title = "Driver's Licenses";
    if (action == 'Update') title = "Update Driver's License";
    if (action == 'View') {
      context.read<DriversLicenseCubit>().getDriversLicenses(user.email!);
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const DriversLicenseBody(),
    );
  }
}
