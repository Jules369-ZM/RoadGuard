part of 'payments_cubit.dart';

/// {@template payments}
/// PaymentsState description
/// {@endtemplate}
class PaymentsState extends Equatable {
  /// {@macro payments}
  const PaymentsState({
    this.message = 'Default Value',
  });

  /// A description for customProperty
  final String message;

  @override
  List<Object> get props => [message];

  /// Creates a copy of the current PaymentsState with property changes
  PaymentsState copyWith({
    String? message,
  }) {
    return PaymentsState(
      message: message ?? this.message,
    );
  }
}
