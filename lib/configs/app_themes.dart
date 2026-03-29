import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

abstract class AppThemes {
  static Map<String, Style> htmlStyle(ColorScheme colorScheme) => {
    'body': Style(textAlign: TextAlign.center, fontSize: FontSize.larger),
    'h1': Style(fontSize: FontSize(24)),
    'h2': Style(fontSize: FontSize(22)),
    'h3': Style(fontSize: FontSize(20)),
    'h4': Style(fontSize: FontSize(18)),
    'h5': Style(fontSize: FontSize(16)),
    'a': Style(
      color: colorScheme.primary,
      textDecorationColor: colorScheme.primary,
    ),
  };
}
