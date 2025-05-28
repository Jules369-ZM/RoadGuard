import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_guard/app/theme/theme.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/profile/view/profile_page.dart';
import 'package:road_guard/settings/cubit/cubit.dart';
import 'package:road_guard/widgets/app_version.dart';

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
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                _buildUserProfile(user),
                const SizedBox(height: 16),
                _buildSectionDivider(),
                const SizedBox(height: 16),
                _buildNotificationSettings(),
                const SizedBox(height: 16),
                _buildSectionDivider(),
                const SizedBox(height: 16),
                _buildLogoutTile(context),
                const SizedBox(height: 16),
              ],
            ),
            const Spacer(),
            const AppVersion(),
            const Divider(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(User user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, ProfilePage.route());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
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
                          fontSize: 18,
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
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
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
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      onTap: () async {
        await _showLogoutDialog(context);
      },
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        'Log out',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
