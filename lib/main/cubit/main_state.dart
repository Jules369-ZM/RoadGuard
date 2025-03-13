part of 'main_cubit.dart';

/// {@template main}
/// MainState description
/// {@endtemplate}
class MainState extends Equatable {
  /// {@macro main}
  const MainState({
    this.message = 'Default Value',
  });

  /// A description for message
  final String message;

  @override
  List<Object> get props => [message];

  /// Creates a copy of the current MainState with property changes
  MainState copyWith({
    String? message,
  }) {
    return MainState(
      message: message ?? this.message,
    );
  }
}

/// {@template main_initial}
/// The initial state of MainState
/// {@endtemplate}
class MainInitial extends MainState {
  /// {@macro main_initial}
  const MainInitial() : super();
}
