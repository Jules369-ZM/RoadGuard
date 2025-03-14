import 'package:flutter/material.dart';
import 'package:road_guard/drivers_license/drivers_license.dart';
import 'package:road_guard/home/cubit/cubit.dart';
import 'package:road_guard/home/widgets/service_row.dart';
import 'package:road_guard/utils/utils.dart';
import 'package:road_guard/widgets/coming_soon.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
            ),
            children: [
              Divider(color: Colors.grey.shade300),
              // Dashboard overview
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenHeight(16)),
                  child: const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Text('Total Fines:'),
                        Spacer(),
                        Text('K500'),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text('License Expiry:'),
                        Spacer(),
                        Text('15 Aug 2025'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),

              // Traffic alert
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenHeight(16)),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red.shade700),
                      SizedBox(width: getProportionateScreenWidth(12)),
                      const Expanded(
                        child: Text(
                          '''Traffic Alert: Accident on Highway 5. Use alternate route!''',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: getProportionateScreenHeight(20)),
              Divider(color: Colors.grey.shade300),
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                child: Text(
                  "Driver's License",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              ServiceButtonsRow(
                children: [
                  Expanded(
                    child: ServiceTileButton(
                      imageUrl: '',
                      // icon: null,
                      text: 'Add',
                      onTap: () {
                        Navigator.push(
                          context,
                          DriversLicensePage.route('Add'),
                        );
                      },
                    ),
                  ),
                  // SizedBox(width: getProportionateScreenWidth(12)),
                  Expanded(
                    child: ComingSoon(
                      child: ServiceTileButton(
                        imageUrl: '',
                        text: 'View',
                        onTap: () {
                          Navigator.push(
                            context,
                            DriversLicensePage.route('View'),
                          );
                        },
                      ),
                    ),
                  ),
                  // SizedBox(width: getProportionateScreenWidth(12)),
                  Expanded(
                    child: ComingSoon(
                      child: ServiceTileButton(
                        imageUrl: '',
                        text: 'Update',
                        onTap: () {
                          Navigator.push(
                            context,
                            DriversLicensePage.route('Update'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: getProportionateScreenHeight(20)),
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                child: Text(
                  'Other',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              const ServiceButtonsRow(
                children: [
                  Expanded(
                    child: ComingSoon(
                      child: ServiceTileButton(
                        imageUrl: '',
                        // icon: null,
                        text: 'Pay Road Tax',
                        // onTap: () {},
                      ),
                    ),
                  ),
                  // SizedBox(width: getProportionateScreenWidth(12)),
                  Expanded(
                    child: ComingSoon(
                      child: ServiceTileButton(
                        imageUrl: '',
                        text: 'Pay Fines',
                        // onTap: () {},
                      ),
                    ),
                  ),
                  // SizedBox(width: getProportionateScreenWidth(12)),
                  Expanded(
                    child: ComingSoon(
                      child: ServiceTileButton(
                        imageUrl: '',
                        text: 'Renew License',
                        // onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        );
      },
    );
  }
}
