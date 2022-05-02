import 'package:flutter/material.dart';
import 'package:islieb/model/islieb_reader.dart';
import 'package:islieb/widgets/islieb_app.dart';

void main() async {
  final isliebReader = await IsliebReader.init();
  runApp(IsliebApp(isliebReader: isliebReader));
}
