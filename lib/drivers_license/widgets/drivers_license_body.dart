import 'package:flutter/material.dart';
import 'package:road_guard/drivers_license/cubit/cubit.dart';

/// {@template drivers_license_body}
/// Body of the DriversLicensePage.
///
/// Add what it does
/// {@endtemplate}
class DriversLicenseBody extends StatelessWidget {
  /// {@macro drivers_license_body}
  const DriversLicenseBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriversLicenseCubit, DriversLicenseState>(
      builder: (context, state) {
        return Center(child: Text(state.message));
      },
    );
  }
}
