import 'package:flutter/material.dart';

class QuickAmount extends StatelessWidget {
  const QuickAmount({
    required this.onTap,
    required this.amount,
    super.key,
    this.margin = 8,
    this.currency = 'ZMW',
  });

  final VoidCallback onTap;
  final String amount;
  final String currency;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: EdgeInsets.only(right: margin),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$currency $amount',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ),
      ),
    );
  }
}
