part of 'notifications_cubit.dart';

/// {@template notifications}
/// NotificationsState description
/// {@endtemplate}
class NotificationsState extends Equatable {
  /// {@macro notifications}
  const NotificationsState({
    this.message = 'Default Value',
  });

  /// A description for message
  final String message;

  @override
  List<Object> get props => [message];

  /// Creates a copy of the current NotificationsState with property changes
  NotificationsState copyWith({
    String? message,
  }) {
    return NotificationsState(
      message: message ?? this.message,
    );
  }
}

/// {@template notifications_initial}
/// The initial state of NotificationsState
/// {@endtemplate}
class NotificationsInitial extends NotificationsState {
  /// {@macro notifications_initial}
  const NotificationsInitial() : super();
}
