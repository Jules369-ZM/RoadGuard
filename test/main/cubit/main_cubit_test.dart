// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:road_guard/main/cubit/cubit.dart';

void main() {
  group('MainCubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          MainCubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for customProperty', () {
      final mainCubit = MainCubit();
      expect(mainCubit.state.customProperty, equals('Default Value'));
    });

    blocTest<MainCubit, MainState>(
      'yourCustomFunction emits nothing',
      build: MainCubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <MainState>[],
    );
  });
}
