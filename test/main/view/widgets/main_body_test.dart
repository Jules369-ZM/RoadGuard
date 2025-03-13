// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:road_guard/main/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MainBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => MainCubit(),
          child: MaterialApp(home: MainBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
