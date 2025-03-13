import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({
    required this.child,
    super.key,
    this.message = 'Coming Soon',
  });

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 24,
      textStyle: TextStyle(
        fontSize: 10,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: child,
    );
  }
}
