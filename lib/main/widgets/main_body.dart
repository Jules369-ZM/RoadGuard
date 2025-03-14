import 'package:flutter/material.dart';
import 'package:road_guard/home/view/home_page.dart';
import 'package:road_guard/main/cubit/cubit.dart';
import 'package:road_guard/notifications/view/notifications_page.dart';
import 'package:road_guard/settings/settings.dart';

/// {@template main_body}
/// Body of the MainPage.
/// {@endtemplate}
class MainBody extends StatelessWidget {
  /// {@macro main_body}
  const MainBody({super.key});

  static const int homeTabIndex = 0;
  static const int notificationsTabIndex = 1;
  static const int settingsTabIndex = 2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return PopScope(
          canPop: state.currentIndex ==
              homeTabIndex, // Only allows back navigation if on HomePage
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && state.currentIndex != homeTabIndex) {
              context.read<MainCubit>().changeTab(homeTabIndex);
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
        NotificationsPage(),
        SettingsPage(),
      ],
    );
  }
}
