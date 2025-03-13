part of 'theme_cubit.dart';

/// {@template theme}
/// ThemeState description
/// {@endtemplate}
class ThemeState extends Equatable {
  /// {@macro theme}
  const ThemeState({this.mode = ThemeMode.system});

  final ThemeMode mode;

  @override
  List<Object> get props => [mode];

  /// Creates a copy of the current ThemeState with property changes
  ThemeState copyWith({ThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }
}
