part of 'drivers_license_cubit.dart';

/// {@template drivers_license}
/// DriversLicenseState description
/// {@endtemplate}
class DriversLicenseState extends Equatable {
  /// {@macro drivers_license}
  const DriversLicenseState({
    this.message = 'Default Value',
    this.action = '',
    this.status = CurrentStatus.initial,
    this.data,
  });

  /// A description for customProperty
  final String message;
  final String action;
  final CurrentStatus status;
  final JsonMap? data;

  @override
  List<Object?> get props => [message, action, status, data];

  /// Creates a copy of the current DriversLicenseState with property changes
  DriversLicenseState copyWith({
    String? message,
    String? action,
    CurrentStatus? status,
    JsonMap? data,
  }) {
    return DriversLicenseState(
      message: message ?? this.message,
      status: status ?? this.status,
      action: action ?? this.action,
      data: data ?? this.data,
    );
  }
}
