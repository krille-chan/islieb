import 'package:flutter/material.dart';
import 'package:islieb/configs/app_constants.dart';
import 'package:islieb/configs/app_themes.dart';
import 'package:islieb/model/islieb_reader.dart';
import 'package:islieb/views/home_view.dart';

class IsliebApp extends StatelessWidget {
  final IsliebReader isliebReader;
  const IsliebApp({required this.isliebReader, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.applicationName,
      home: const HomeView(),
      builder: isliebReader.builder,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
    );
  }
}
