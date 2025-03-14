import 'package:flutter/material.dart';
import 'package:road_guard/settings/cubit/cubit.dart';

/// {@template settings_body}
/// Body of the SettingsPage.
///
/// Add what it does
/// {@endtemplate}
class SettingsBody extends StatelessWidget {
  /// {@macro settings_body}
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Center(child: Text(state.message));
      },
    );
  }
}
