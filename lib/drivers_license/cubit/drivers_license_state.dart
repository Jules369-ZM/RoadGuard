part of 'drivers_license_cubit.dart';

/// {@template drivers_license}
/// DriversLicenseState description
/// {@endtemplate}
class DriversLicenseState extends Equatable {
  /// {@macro drivers_license}
  const DriversLicenseState({
    this.message = 'Default Value',
    this.action = '',
  });

  /// A description for customProperty
  final String message;
  final String action;

  @override
  List<Object> get props => [message, action];

  /// Creates a copy of the current DriversLicenseState with property changes
  DriversLicenseState copyWith({
    String? message,
    String? action,
  }) {
    return DriversLicenseState(
      message: message ?? this.message,
      action: action ?? this.action,
    );
  }
}
