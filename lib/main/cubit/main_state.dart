part of 'main_cubit.dart';

/// {@template main}
/// MainState description
/// {@endtemplate}
class MainState extends Equatable {
  /// {@macro main}
  const MainState({
    this.customProperty = 'Default Value',
  });

  /// A description for customProperty
  final String customProperty;

  @override
  List<Object> get props => [customProperty];

  /// Creates a copy of the current MainState with property changes
  MainState copyWith({
    String? customProperty,
  }) {
    return MainState(
      customProperty: customProperty ?? this.customProperty,
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
