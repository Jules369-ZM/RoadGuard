
import 'package:flutter/material.dart';
import 'package:road_guard/utils/strings.dart';


class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    this.message = Strings.somethingWrong,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
