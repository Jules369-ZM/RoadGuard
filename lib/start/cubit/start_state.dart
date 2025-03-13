part of 'start_cubit.dart';

/// {@template start}
/// StartState description
/// {@endtemplate}
class StartState extends Equatable {
  /// {@macro start}
  const StartState({
    this.message = 'Default Value',
  });

  /// A description for customProperty
  final String message;

  @override
  List<Object> get props => [message];

  /// Creates a copy of the current StartState with property changes
  StartState copyWith({
    String? message,
  }) {
    return StartState(
      message: message ?? this.message,
    );
  }
}

/// {@template start_initial}
/// The initial state of StartState
/// {@endtemplate}
class StartInitial extends StartState {
  /// {@macro start_initial}
  const StartInitial() : super();
}
