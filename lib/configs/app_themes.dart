import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/style.dart';

abstract class AppThemes {
  static ThemeData get light => ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              backgroundColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.25),
              elevation: 10,
              foregroundColor: Colors.black,
              systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.white,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
            ),
      );
  static ThemeData get dark => ThemeData.dark().copyWith();

  static final Map<String, Style> htmlStyle = {
    'body': Style(
      textAlign: TextAlign.center,
      fontSize: FontSize.larger,
    ),
  };
}
