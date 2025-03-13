// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:road_guard/main/cubit/cubit.dart';

void main() {
  group('MainState', () {
    test('supports value equality', () {
      expect(
        MainState(),
        equals(
          const MainState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const MainState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const mainState = MainState(
            customProperty: 'My property',
          );
          expect(
            mainState.copyWith(),
            equals(mainState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const mainState = MainState(
            customProperty: 'My property',
          );
          final otherMainState = MainState(
            customProperty: 'My property 2',
          );
          expect(mainState, isNot(equals(otherMainState)));

          expect(
            mainState.copyWith(
              customProperty: otherMainState.customProperty,
            ),
            equals(otherMainState),
          );
        },
      );
    });
  });
}
