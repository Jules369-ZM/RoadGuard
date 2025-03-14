part of 'main_cubit.dart';

/// {@template main}
/// MainState description
/// {@endtemplate}
class MainState extends Equatable {
  /// {@macro main}
  const MainState({
    this.message = 'Default Value',
    this.currentIndex = 0,
  });

  /// A description for message
  final String message;
  final int currentIndex;

  @override
  List<Object> get props => [message, currentIndex];

  /// Creates a copy of the current MainState with property changes
  MainState copyWith({
    String? message,
    int? currentIndex,
  }) {
    return MainState(
      message: message ?? this.message,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
