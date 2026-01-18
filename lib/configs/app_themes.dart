import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_html/flutter_html.dart';

abstract class AppThemes {
  static final Map<String, Style> htmlStyle = {
    'body': Style(textAlign: TextAlign.center, fontSize: FontSize.larger),
  };
}
