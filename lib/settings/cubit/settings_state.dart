part of 'settings_cubit.dart';

/// {@template settings}
/// SettingsState description
/// {@endtemplate}
class SettingsState extends Equatable {
  /// {@macro settings}
  const SettingsState({
    this.message = 'Default Value',
  });

  /// A description for message
  final String message;

  @override
  List<Object> get props => [message];

  /// Creates a copy of the current SettingsState with property changes
  SettingsState copyWith({
    String? message,
  }) {
    return SettingsState(
      message: message ?? this.message,
    );
  }
}

/// {@template settings_initial}
/// The initial state of SettingsState
/// {@endtemplate}
class SettingsInitial extends SettingsState {
  /// {@macro settings_initial}
  const SettingsInitial() : super();
}
