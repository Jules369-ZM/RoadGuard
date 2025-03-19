import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_client/permission_client.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/bootstrap.dart';
import 'package:road_guard/drivers_license/drivers_license.dart';
import 'package:road_guard/home/view/home_page.dart';
import 'package:road_guard/main/cubit/cubit.dart';
import 'package:road_guard/notifications/view/notifications_page.dart';
import 'package:road_guard/settings/settings.dart';
import 'package:road_guard/utils/constants.dart';

/// {@template main_body}
/// Body of the MainPage.
/// {@endtemplate}
class MainBody extends StatefulWidget {
  /// {@macro main_body}
  const MainBody({super.key});

  static const int homeTabIndex = 0;
  static const int notificationsTabIndex = 1;
  static const int settingsTabIndex = 2;

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  void initState() {
    super.initState();
    checkPermissions();
    FirebaseMessaging.instance.getInitialMessage().then(
          (value) {},
        );
    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
    });
  }

  Future<void> checkPermissions() async {
    try {
      final permissionClient = navKey.currentContext!.read<PermissionClient>();
      final pStatus = await permissionClient.notificationsStatus();
      if (pStatus != PermissionStatus.granted) {
        await permissionClient.requestNotifications();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    getToken(context);

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return PopScope(
          canPop: state.currentIndex ==
              MainBody
                  .homeTabIndex, // Only allows back navigation if on HomePage
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && state.currentIndex != MainBody.homeTabIndex) {
              context.read<MainCubit>().changeTab(MainBody.homeTabIndex);
            }
            // Handle result if needed
          },
          child: Scaffold(
            body: _buildBody(state.currentIndex),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) => context.read<MainCubit>().changeTab(index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.credit_card),
                  label: 'License',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(int index) {
    return IndexedStack(
      index: index,
      children: const [
        HomePage(),
        DriversLicensePage(),
        NotificationsPage(),
        SettingsPage(),
      ],
    );
  }
}

Future<void> getToken(BuildContext c) async {
  final token = await FirebaseMessaging.instance.getToken();
  log('Token== $token');
  if (token == null) return;
  if (!c.mounted) return;
  final user = c.read<AuthBloc>().state.user;
  await c.read<MainCubit>().sendToken(token, user);
  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    if (!c.mounted) return;
    await c.read<MainCubit>().sendToken(token, user);
  });
}
