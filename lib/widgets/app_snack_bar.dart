import 'package:flutter/material.dart';

void showInfoSnackBar(
  BuildContext context, {
  String message = '',
  int seconds = 4,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    defaultSnackBar(message, seconds, MessageType.info),
  );
}

void showSuccessSnackBar(
  BuildContext context, {
  String message = '',
  int seconds = 2,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    defaultSnackBar(message, seconds, MessageType.success),
  );
}

void showErrorSnackBar(
  BuildContext context, {
  String message = '',
  int seconds = 4,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    defaultSnackBar(message, seconds, MessageType.error),
  );
}

enum MessageType { info, success, error }

void showAppSnackBar(
  ScaffoldMessengerState messenger, {
  String message = '',
  int seconds = 4,
  MessageType type = MessageType.info,
}) {
  messenger.showSnackBar(defaultSnackBar(message, seconds, type));
}

SnackBar defaultSnackBar(String message, int seconds, MessageType type) {
  Color color;
  Color darkColor;
  IconData iconData;
  String title;
  if (type == MessageType.success) {
    color = Colors.green;
    darkColor = Colors.green.shade900.withValues(alpha: 0.9);
    iconData = Icons.check_circle;
    title = 'Success';
  } else if (type == MessageType.error) {
    color = Colors.red;
    darkColor = Colors.red.shade900.withValues(alpha: 0.9);
    iconData = Icons.error;
    title = 'Error';
  } else {
    color = Colors.blue;
    darkColor = Colors.blue.shade900.withValues(alpha: 0.9);
    iconData = Icons.info;
    title = 'Note';
  }

  return SnackBar(
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(iconData, color: color, size: 16),
        const SizedBox(width: 8),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: '$title. ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: message,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    duration: Duration(seconds: seconds),
    backgroundColor: darkColor,
    behavior: SnackBarBehavior.floating,
  );
}
