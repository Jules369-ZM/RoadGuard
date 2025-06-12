// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:road_guard/road_tax/road_tax.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoadTaxBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => RoadTaxCubit(),
          child: MaterialApp(home: RoadTaxBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
