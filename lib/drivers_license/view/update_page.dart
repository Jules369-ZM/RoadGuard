import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_guard/drivers_license/cubit/drivers_license_cubit.dart';
import 'package:road_guard/drivers_license/widgets/update_driver_license.dart';
import 'package:road_guard/models/models.dart';

class UpdateDriverLicensePage extends StatelessWidget {
  const UpdateDriverLicensePage({super.key});

  /// The static route for UpdateDriverLicensePage
  static Route<dynamic> route(DriverLicense license) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const UpdateDriverLicensePage(),
      settings: RouteSettings(arguments: license),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriversLicenseCubit(context.read()),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Driver License')),
      body: const UpdateDriversLicenseBody(),
    );
  }
}
