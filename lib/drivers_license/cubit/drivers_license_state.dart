part of 'drivers_license_cubit.dart';

/// {@template drivers_license}
/// DriversLicenseState description
/// {@endtemplate}
class DriversLicenseState extends Equatable {
  /// {@macro drivers_license}
  const DriversLicenseState({
    this.message = 'Default Value',
    this.action = '',
    this.title = '',
    this.status = CurrentStatus.initial,
    this.data,
  });

  /// A description for customProperty
  final String message;
  final String action;
  final String title;
  final CurrentStatus status;
  final JsonMap? data;
  bool get isLoading=>status==CurrentStatus.loading;

  @override
  List<Object?> get props => [message, action, status, data, title];

  /// Creates a copy of the current DriversLicenseState with property changes
  DriversLicenseState copyWith({
    String? message,
    String? action,
    String? title,
    CurrentStatus? status,
    JsonMap? data,
  }) {
    return DriversLicenseState(
      message: message ?? this.message,
      status: status ?? this.status,
      title: title ?? this.title,
      action: action ?? this.action,
      data: data ?? this.data,
    );
  }
}
