part of 'home_cubit.dart';

/// {@template home}
/// HomeState description
/// {@endtemplate}
class HomeState extends Equatable {
  /// {@macro home}
  const HomeState({
    this.message = 'Default Value',
  });

  /// A description for message
  final String message;

  @override
  List<Object> get props => [message];

  /// Creates a copy of the current HomeState with property changes
  HomeState copyWith({
    String? message,
  }) {
    return HomeState(
      message: message ?? this.message,
    );
  }
}

/// {@template home_initial}
/// The initial state of HomeState
/// {@endtemplate}
class HomeInitial extends HomeState {
  /// {@macro home_initial}
  const HomeInitial() : super();
}
