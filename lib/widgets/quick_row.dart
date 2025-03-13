import 'package:flutter/material.dart';
import 'package:road_guard/utils/utils.dart';
import 'package:road_guard/widgets/quick_amount.dart';

class QuickRow extends StatelessWidget {
  const QuickRow({required this.onTap, super.key, this.recent});
  final void Function(String amount) onTap;
  final List<double>? recent;

  @override
  Widget build(BuildContext context) {
    final defaultList = {'200.00', '100.00', '50.00'};
    if (recent != null) {
      for (final item in recent!) {
        final safeAmt = item.toString().replaceAll(',', '');
        final amt = formatAmount(double.parse(safeAmt));
        if (amt != '0.00') {
          defaultList.add(amt);
        }
      }
    }
    final displayedList = defaultList.toList().reversed.toList();
    return Row(
      children: List.generate(
        3,
            (index) {
          final amt = displayedList[index];
          return QuickAmount(
            onTap: () => onTap(amt.replaceAll(',', '')),
            amount: amt,
            margin: index == 2 ? 0 : 8,
          );
        },
      ),
    );
  }
}
