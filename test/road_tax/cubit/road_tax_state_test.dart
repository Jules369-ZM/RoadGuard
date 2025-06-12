// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:road_guard/road_tax/cubit/cubit.dart';

void main() {
  group('RoadTaxState', () {
    test('supports value equality', () {
      expect(
        RoadTaxState(),
        equals(
          const RoadTaxState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const RoadTaxState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const roadTaxState = RoadTaxState(
            message: 'My property',
          );
          expect(
            roadTaxState.copyWith(),
            equals(roadTaxState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const roadTaxState = RoadTaxState(
            message: 'My property',
          );
          final otherRoadTaxState = RoadTaxState(
            message: 'My property 2',
          );
          expect(roadTaxState, isNot(equals(otherRoadTaxState)));

          expect(
            roadTaxState.copyWith(
              message: otherRoadTaxState.message,
            ),
            equals(otherRoadTaxState),
          );
        },
      );
    });
  });
}
