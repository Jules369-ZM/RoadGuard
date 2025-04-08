import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  // Constructor
  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.body,
    required this.timestamp,
    required this.isRead,
  });

  // Factory method to create a Notification instance from a
  // map (e.g., from Firestore)
  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      body: map['body'] as String? ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ??
          DateTime.now(), // Handle invalid date format
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  final String id;
  final String title;
  final String message;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  // Method to convert the Notification instance to a map
  //(for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Update the isRead status or other fields of the notification
  Notification copyWith({
    String? id,
    String? title,
    String? message,
    String? body,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, message, body, timestamp, isRead];
}
