part of 'road_tax_cubit.dart';

/// {@template road_tax}
/// RoadTaxState description
/// {@endtemplate}
class RoadTaxState extends Equatable {
  /// {@macro road_tax}
  const RoadTaxState({
    this.message = 'Default Value',
    this.action = 'Default Value',
    this.title = 'Default Value',
    this.status = CurrentStatus.initial,
    this.data,
  });

  /// A description for message
  final String message;
  final String action;
  final String title;
  final CurrentStatus status;
  final JsonMap? data;
  bool get isLoading => status == CurrentStatus.loading;

  @override
  List<Object?> get props => [message, action, title, status, data];

  /// Creates a copy of the current RoadTaxState with property changes
  RoadTaxState copyWith({
    String? message,
    String? action,
    String? title,
    CurrentStatus? status,
    JsonMap? data,
  }) {
    return RoadTaxState(
      message: message ?? this.message,
      status: status ?? this.status,
      title: title ?? this.title,
      action: action ?? this.action,
      data: data ?? this.data,
    );
  }
}
