import 'package:flutter/material.dart';
import 'package:islieb/model/islieb_reader.dart';
import 'package:islieb/widgets/islieb_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final isliebReader = await IsliebReader.init();
  runApp(IsliebApp(isliebReader: isliebReader));
}
