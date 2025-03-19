// ignore_for_file: doc_directive_missing_closing_tag

import 'package:flutter/material.dart';
import 'package:road_guard/notifications/cubit/cubit.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/widgets/loading_screen.dart';
import 'package:road_guard/widgets/message_screen.dart';
import 'package:road_guard/widgets/widgets.dart';

/// {@template notifications_body}
/// Body of the NotificationsPage.
///
class NotificationsBody extends StatelessWidget {
  /// {@macro notifications_body}
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state.status == CurrentStatus.loading) {
          return const LoadingScreen();


        } else if (state.status == CurrentStatus.success) {
          if (state.notifications.isEmpty) {
            return const MessageScreen(message: 'No notifications available.');

          }

          // Display a list of notifications
          return ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return ListTile(
                leading: Icon(notification.isRead
                    ? Icons.mark_chat_read
                    : Icons.mark_chat_unread,),
                title: Text(notification.title),
                subtitle: Text(notification.message),
                trailing: Text(
                  notification.timestamp.toLocal().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  // Handle notification tap (e.g., mark as read)
                },
              );
            },
          );
        } else if (state.status == CurrentStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 16),
                AppButton(
                  type: ButtonType.outlined,
                  onPressed: () {
                    context.read<NotificationsCubit>().fetchNotifications();
                  },
                  text: 'Retry',
                ),
              ],
            ),
          );
        } else {
          return const MessageScreen(message:  'No notifications found')  ;}
      },
    );
  }
}
