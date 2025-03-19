part of 'notifications_cubit.dart';

/// {@template notifications}
/// NotificationsState description
/// {@endtemplate}
class NotificationsState extends Equatable {
  /// {@macro notifications}
  const NotificationsState({
    this.message = 'Default Value',
    this.status = CurrentStatus.initial,
    this.notifications = const [],
  });

  /// A description for message
  final String message;
  final CurrentStatus status;
  final List<Notification> notifications;

  @override
  List<Object> get props => [message, status, notifications];

  /// Creates a copy of the current NotificationsState with property changes
  NotificationsState copyWith({
    String? message,
    CurrentStatus? status,
    List<Notification>? notifications,
  }) {
    return NotificationsState(
      message: message ?? this.message,
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
    );
  }
}
