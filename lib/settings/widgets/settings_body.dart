// ignore_for_file: doc_directive_missing_closing_tag

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_guard/app/theme/theme.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/settings/cubit/cubit.dart';

/// {@template settings_body}
/// Body of the SettingsPage.
/// {@endtemplate}
class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            _buildUserProfile(user),
            _buildSectionDivider(),
            _buildNotificationSettings(),
            _buildSectionDivider(),
            _buildLogoutTile(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: user.avatar != null
                ? NetworkImage(user.avatar!)
                : const AssetImage('assets/person.png') as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'User Name',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? 'user@example.com',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          // IconButton(
          // icon: const Icon(Icons.edit),
          // onPressed: () {
          // },
          // ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider() {
    return const Divider(
      thickness: 1,
      color: Colors.grey,
    );
  }

  /// Build the notification settings section with modern UI
  Widget _buildNotificationSettings() {
    return SwitchListTile(
      title: const Text(
        'Enable Notifications',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle:
          const Text('Receive notifications for service requests and updates'),
      value: _notificationsEnabled,
      onChanged: (bool value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
      activeColor: Theme.of(context).colorScheme.primary,
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      // dense: true,
      onTap: () async {
        await _showLogoutDialog(context);
      },
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Log out'),
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value == true && context.mounted) {
        context.read<AuthBloc>().add(AuthLogoutRequested());
      }
    });
  }
}
