import 'package:flutter/material.dart';
import 'package:road_guard/main/main.dart';
import 'package:road_guard/road_tax/road_tax.dart';
import 'package:road_guard/road_tax/widgets/add_tax.dart';
import 'package:road_guard/road_tax/widgets/tax_list.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/widgets/widgets.dart';

/// {@template drivers_license_body}
/// Body of the DriversLicensePage.
///
/// Add what it does
/// {@endtemplate}
class RoadTaxBody extends StatefulWidget {
  /// {@macro drivers_license_body}
  const RoadTaxBody({super.key});

  @override
  State<RoadTaxBody> createState() => _RoadTaxBodyState();
}

class _RoadTaxBodyState extends State<RoadTaxBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoadTaxCubit, RoadTaxState>(
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
          return const AddTaxBody();
        }

        if (state.action == 'View') {
          return const RoadTaxList();
        }
        if (state.action == 'Update') {
          return const RoadTaxList();
        }
        return Center(child: Text(state.message));
      },
    );
  }
}
