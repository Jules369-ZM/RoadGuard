import 'package:flutter/material.dart';
import 'package:net_source/net_source.dart';
import 'package:road_guard/drivers_license/cubit/cubit.dart';
import 'package:road_guard/drivers_license/widgets/view_driver_license.dart';
import 'package:road_guard/models/models.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/utils/utils.dart';
import 'package:road_guard/widgets/action_sheet.dart';
import 'package:road_guard/widgets/loading_screen.dart';
import 'package:road_guard/widgets/message_screen.dart';

class DriverLicenseList extends StatelessWidget {
  const DriverLicenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DriverLicenseListView();
  }
}

class _DriverLicenseListView extends StatelessWidget {
  const _DriverLicenseListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriversLicenseCubit, DriversLicenseState>(
      builder: (context, state) {
        if (state.status == CurrentStatus.loading) {
          return const LoadingScreen();
        }
        if (state.status == CurrentStatus.error) {
          return MessageScreen(message: state.message);
        }
        final driversLicenses =
            state.data?['driversLicenses'] as List<JsonMap>? ?? [];
        if (driversLicenses.isEmpty) {
          return const MessageScreen(message: 'No drivers licenses found');
        }
        final licenses = driversLicenses.map(DriverLicense.fromMap).toList();
        return ListView.builder(
          itemCount: licenses.length,
          padding: EdgeInsets.all(getProportionateScreenHeight(8)),
          itemBuilder: (ct, i) {
            final license = licenses[i];
            final isExpired = license.isExpired;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                onTap: () {
                  showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    builder: (c) {
                      return ActionSheet(
                        actions: [
                          ViewDriversLicenseBody(license: license),
                        ],
                      );
                    },
                  );
                },
                contentPadding: EdgeInsets.zero,
                leading: license.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          license.image!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.image, size: 50, color: Colors.grey),
                title: Text(
                  license.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  children: [
                    Text('License No: ${license.licenseNumber}'),
                    Text(
                      '''Issued Date: ${license.issuedDate.toLocal()}'''
                          .split(' ')[0],
                    ),
                    Text(
                      // ignore: lines_longer_than_80_chars
                      '${'''Expiry Date: ${license.expiryDate.toLocal()}'''.split(' ')[0]}\n'
                      '',
                    ),
                    Text(
                      'Status: ${license.currentStatus}',
                      style: TextStyle(
                        color: isExpired ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
