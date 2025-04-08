import 'package:flutter/material.dart';
import 'package:road_guard/drivers_license/cubit/cubit.dart';
import 'package:road_guard/drivers_license/widgets/add_driver_licence.dart';
import 'package:road_guard/drivers_license/widgets/driver_license_list.dart';
import 'package:road_guard/main/main.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/widgets/widgets.dart';

/// {@template drivers_license_body}
/// Body of the DriversLicensePage.
///
/// Add what it does
/// {@endtemplate}
class DriversLicenseBody extends StatefulWidget {
  /// {@macro drivers_license_body}
  const DriversLicenseBody({super.key});

  @override
  State<DriversLicenseBody> createState() => _DriversLicenseBodyState();
}

class _DriversLicenseBodyState extends State<DriversLicenseBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriversLicenseCubit, DriversLicenseState>(
      listener: (context, state) {
        if (state.status == CurrentStatus.error) {
          showErrorSnackBar(context, message: state.message);
        }
        if (state.status == CurrentStatus.success) {
          showSuccessSnackBar(context, message: state.message);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MainPage.route(),
                (Route<dynamic> route) => false,
              );
            }
          });
        }
      },
      builder: (context, state) {
        if (state.action == 'Add') {
          return const AddDriversLicenseBody();
        }

        if (state.action == 'View') {
          return const DriverLicenseList();
        }
        if (state.action == 'Update') {
          return const DriverLicenseList();
          // return const UpdateDriversLicenseBody();
        }
        return Center(child: Text(state.message));
      },
    );
  }
}
