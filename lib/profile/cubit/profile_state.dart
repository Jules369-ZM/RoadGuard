part of 'profile_cubit.dart';

/// {@template profile}
/// ProfileState description
/// {@endtemplate}
class ProfileState extends Equatable {
  /// {@macro profile}
  const ProfileState({
    this.message = 'Default Value',
    this.status = CurrentStatus.initial,
  });

  /// A description for customProperty
  final String message;
  final CurrentStatus status;

  @override
  List<Object> get props => [message, status];

  /// Creates a copy of the current ProfileState with property changes
  ProfileState copyWith({
    String? message,
    CurrentStatus? status,
  }) {
    return ProfileState(
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
