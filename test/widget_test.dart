// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:islieb/model/islieb_reader.dart';
import 'package:islieb/widgets/islieb_app.dart';

void main() {
  testWidgets('Test if the app starts', (WidgetTester tester) async {
    final isliebReader = await IsliebReader.init();
    (IsliebApp(isliebReader: isliebReader));
  });
}
