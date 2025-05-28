import 'package:flutter/material.dart';
import 'package:road_guard/auth/auth_bloc.dart';
import 'package:road_guard/models/notification.dart' as noti;
import 'package:road_guard/notifications/cubit/cubit.dart';
import 'package:road_guard/utils/enums.dart';
import 'package:road_guard/widgets/loading_screen.dart';
import 'package:road_guard/widgets/message_screen.dart';
import 'package:road_guard/widgets/widgets.dart';

/// Body of the NotificationsPage.
class NotificationsBody extends StatefulWidget {
  const NotificationsBody({super.key});

  @override
  NotificationsBodyState createState() => NotificationsBodyState();
}

class NotificationsBodyState extends State<NotificationsBody> {
  /// The index of the notification that was tapped
  int? _selectedNotificationIndex;

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

          return Stack(
            children: [
              // Display a list of notifications
              ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle the selected notification
                        if (_selectedNotificationIndex == index) {
                          _selectedNotificationIndex = null;
                        } else {
                          _selectedNotificationIndex = index;
                        }
                      });
                    },
                    child: ListTile(
                      selected: _selectedNotificationIndex == index,
                      dense: true,
                      leading: Icon(
                        notification.isRead
                            ? Icons.mark_chat_read
                            : Icons.mark_chat_unread,
                      ),
                      title: Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.body),
                          const SizedBox(height: 8),
                          Text(
                            notification.timestamp.toLocal().toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Show the overlay for the selected notification
              if (_selectedNotificationIndex != null) ...[
                Positioned(
                  top: _getOverlayPosition(
                    state.notifications[_selectedNotificationIndex!],
                  ),
                  left: 16,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.notifications[_selectedNotificationIndex!]
                                  .title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.notifications[_selectedNotificationIndex!]
                                  .message,
                            ),
                            const Divider(color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              state.notifications[_selectedNotificationIndex!]
                                  .body,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.notifications[_selectedNotificationIndex!]
                                  .timestamp
                                  .toLocal()
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
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
                    final user = context.read<AuthBloc>().state.user;
                    context
                        .read<NotificationsCubit>()
                        .fetchNotifications(user.email!);
                  },
                  text: 'Retry',
                ),
              ],
            ),
          );
        } else {
          return const MessageScreen(message: 'No notifications found');
        }
      },
    );
  }

  // Determine the position of the overlay based on the tapped notification
  double _getOverlayPosition(noti.Notification notification) {
    // You can calculate the exact position of the notification and overlay here
    // For simplicity, we are returning a fixed position,
    //but you can adjust this.
    return 80; // Adjust based on your layout and design
  }
}
