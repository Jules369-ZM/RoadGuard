// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:road_guard/main/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MainPage', () {
    group('route', () {
      test('is routable', () {
        expect(MainPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders MainView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: MainPage()));
      expect(find.byType(MainView), findsOneWidget);
    });
  });
}
