import 'package:intl/intl.dart';

export 'size_config.dart';

String formatMoney(dynamic number, {String? currency = 'ZMW '}) {
  final moneyFormat = NumberFormat.currency(name: currency);
  return moneyFormat.format(number);
}

String formatAmount(dynamic number) {
  final amount = double.tryParse(number.toString());
  if (amount != null) {
    return NumberFormat('#,##0.00').format(amount);
  }
  return '-';
}

extension StringExtension on String {
  String? toCapitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
