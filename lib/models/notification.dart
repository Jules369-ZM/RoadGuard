import 'package:cloud_firestore/cloud_firestore.dart';
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
    required this.recipientEmail,
    required this.type,
    required this.createdAt,
  });

  // Factory method to create a Notification instance from Firestore map
  factory Notification.fromMap(Map<String, dynamic> map) {
    final rawTimestamp = map['timestamp'];

    return Notification(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      body: map['body'] as String? ?? '',
      timestamp: rawTimestamp is Timestamp
          ? rawTimestamp.toDate()
          : DateTime.tryParse(rawTimestamp?.toString() ?? '') ?? DateTime.now(),
      createdAt: rawTimestamp is Timestamp
          ? rawTimestamp.toDate()
          : DateTime.tryParse(rawTimestamp?.toString() ?? '') ?? DateTime.now(),
      isRead: map['isRead'] as bool? ?? false,
      recipientEmail: map['recipientEmail'] as String? ?? '',
      type: map['type'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String message;
  final String body;
  final DateTime timestamp;
  final DateTime createdAt;
  final bool isRead;
  final String recipientEmail;
  final String type;

  // Convert the Notification instance to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'body': body,
      'timestamp': Timestamp.fromDate(timestamp),
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'recipientEmail': recipientEmail,
      'type': type,
    };
  }

  // Create a new instance with updated fields
  Notification copyWith({
    String? id,
    String? title,
    String? message,
    String? body,
    DateTime? timestamp,
    DateTime? createdAt,
    bool? isRead,
    String? recipientEmail,
    String? type,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        body,
        timestamp,
        isRead,
        recipientEmail,
        type,
      ];
}
