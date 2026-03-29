import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

extension LocalizedDate on DateTime {
  String getLocalizedDate(BuildContext context) {
    final today = DateTime.now();
    if (today.day == day && today.month == month && today.year == year) {
      return 'Heute';
    }
    if (today.year == year) {
      return DateFormat.MMMEd().format(this);
    }
    return DateFormat.yMMMEd().format(this);
  }
}
