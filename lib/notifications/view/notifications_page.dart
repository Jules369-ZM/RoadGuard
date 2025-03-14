import 'package:flutter/material.dart';
import 'package:road_guard/notifications/cubit/cubit.dart';
import 'package:road_guard/notifications/widgets/notifications_body.dart';

/// {@template notifications_page}
/// A description for NotificationsPage
/// {@endtemplate}
class NotificationsPage extends StatelessWidget {
  /// {@macro notifications_page}
  const NotificationsPage({super.key});

  /// The static route for NotificationsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const NotificationsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const NotificationsView(),
      ),
    );
  }
}

/// {@template notifications_view}
/// Displays the Body of NotificationsView
/// {@endtemplate}
class NotificationsView extends StatelessWidget {
  /// {@macro notifications_view}
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationsBody();
  }
}
