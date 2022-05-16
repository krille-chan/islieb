import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:islieb/model/islieb_reader.dart';
import 'package:islieb/widgets/islieb_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  log('Welcome to islieb Comic Reader app logs :-) <3');
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e, s) {
    log(
      'Unable to initialize Firebase App!',
      error: e,
      stackTrace: s,
    );
  }
  final isliebReader = await IsliebReader.init();
  runApp(IsliebApp(isliebReader: isliebReader));
}
