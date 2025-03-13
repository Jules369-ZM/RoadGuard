import 'dart:async';
import 'package:flutter/material.dart';

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({super.key});

  @override
  GreetingWidgetState createState() => GreetingWidgetState();
}

class GreetingWidgetState extends State<GreetingWidget> {
  late String greeting;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    greeting = '${getGreeting()},\nwelcome to';
    // Set up a timer to update the greeting every minute
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        greeting = '${getGreeting()},\nwelcome to';
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Clean up the timer to avoid memory leaks
    super.dispose();
  }

  // Function to get greeting based on the time of day
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      greeting,
      // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      style: const TextStyle(
        color: Colors.white, // Text color
        fontSize: 12, // Adjust the font size as needed
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            color: Colors.black54, // Shadow color
          ),
        ],
      ),
    );
  }
}
