import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';

import 'package:islieb/configs/app_constants.dart';
import 'package:islieb/model/islieb_reader.dart';
import 'package:islieb/views/home_view.dart';

class IsliebApp extends StatelessWidget {
  final IsliebReader isliebReader;
  const IsliebApp({required this.isliebReader, super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
          MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.applicationName,
            home: const HomeView(),
            builder: isliebReader.builder,
            theme: ThemeData.light().copyWith(colorScheme: lightDynamic),
            darkTheme: ThemeData.dark().copyWith(colorScheme: darkDynamic),
          ),
    );
  }
}
