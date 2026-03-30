import 'package:flutter/material.dart';

extension LocalizedDate on DateTime {
  String getLocalizedDate(BuildContext context) {
    final today = DateTime.now();
    if (today.day == day && today.month == month && today.year == year) {
      return 'Heute';
    }
    final dayStr = day < 10 ? '0$day' : day.toString();
    final monthStr = month < 10 ? '0$month' : month.toString();
    if (today.year == year) {
      return '$dayStr.$monthStr';
    }
    return '$dayStr.$monthStr.$year';
  }
}
