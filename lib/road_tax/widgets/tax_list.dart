import 'package:flutter/material.dart';
import 'package:net_source/net_source.dart';
import 'package:road_guard/models/road_tax.dart';
import 'package:road_guard/road_tax/road_tax.dart';
import 'package:road_guard/road_tax/view/update_page.dart';
import 'package:road_guard/road_tax/widgets/view_tax.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/utils/utils.dart';
import 'package:road_guard/widgets/action_sheet.dart';
import 'package:road_guard/widgets/loading_screen.dart';
import 'package:road_guard/widgets/message_screen.dart';

class RoadTaxList extends StatelessWidget {
  const RoadTaxList({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DriverLicenseListView();
  }
}

class _DriverLicenseListView extends StatelessWidget {
  const _DriverLicenseListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadTaxCubit, RoadTaxState>(
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
          context.read<RoadTaxCubit>().updateAction('Add');
          return const MessageScreen(message: 'No drivers licenses found');
        }
        final licenses = driversLicenses.map(RoadTax.fromMap).toList();
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
                dense: true,
                contentPadding: const EdgeInsets.all(8),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      UpdateRoadTaxPage.route(license),
                    );
                  },
                ),
                onTap: () {
                  showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    builder: (c) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ActionSheet(
                          title: "Driver's License",
                          actions: [
                            ViewTaxBody(
                              license: license,
                              onTap: () {
                                Navigator.pop(c);
                                Navigator.push(
                                  context,
                                  UpdateRoadTaxPage.route(license),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
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
                  license.makeAndModel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow('Number Plate:', license.numberPlate),
                    // buildDetailRow('Issued Date:',
                    // license.formattedIssuedDate),
                    // buildDetailRow('Expiry Date:',
                    // license.formattedExpiryDate),
                    // const Divider(),
                    buildDetailRow(
                      'Status:',
                      license.currentStatus,
                      color: isExpired ? Colors.red : Colors.green,
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
