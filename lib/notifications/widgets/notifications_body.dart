import 'package:flutter/material.dart';
import 'package:road_guard/notifications/cubit/cubit.dart';

/// {@template notifications_body}
/// Body of the NotificationsPage.
///
/// Add what it does
/// {@endtemplate}
class NotificationsBody extends StatelessWidget {
  /// {@macro notifications_body}
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return Center(child: Text(state.message));
      },
    );
  }
}
