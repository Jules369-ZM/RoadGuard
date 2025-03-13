import 'package:flutter/material.dart';

enum ButtonType { filled, elevated, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text, super.key,
    this.loading = false,
    this.icon = Icons.arrow_forward,
    this.loadingText = 'Loading...',
    this.onPressed,
    this.type = ButtonType.filled,
  });

  final bool loading;
  final String text;
  final String loadingText;
  final IconData icon;
  final VoidCallback? onPressed;
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    const size = Size.fromHeight(56);
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
    final child = Row(
      children: [
        Text(loading ? loadingText : text),
        const Spacer(),
        if (loading)
          const SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
          )
        else
          Icon(icon),
      ],
    );
    switch (type) {
      case ButtonType.filled:
        return FilledButton(
          style: FilledButton.styleFrom(minimumSize: size, shape: shape),
          onPressed: loading ? null : onPressed,
          child: child,
        );
      case ButtonType.elevated:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: size, shape: shape),
          onPressed: loading ? null : onPressed,
          child: child,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: size, shape: shape),
          onPressed: loading ? null : onPressed,
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          style: TextButton.styleFrom(minimumSize: size, shape: shape),
          onPressed: loading ? null : onPressed,
          child: child,
        );
    }
  }
}
