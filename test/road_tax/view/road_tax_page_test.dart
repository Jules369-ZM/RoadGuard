// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:road_guard/road_tax/road_tax.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoadTaxPage', () {
    group('route', () {
      test('is routable', () {
        expect(RoadTaxPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders RoadTaxView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: RoadTaxPage()));
      expect(find.byType(RoadTaxView), findsOneWidget);
    });
  });
}
