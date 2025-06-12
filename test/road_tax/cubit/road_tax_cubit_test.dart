// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:road_guard/road_tax/cubit/cubit.dart';

void main() {
  group('RoadTaxCubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          RoadTaxCubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for message', () {
      final roadTaxCubit = RoadTaxCubit();
      expect(roadTaxCubit.state.message, equals('Default Value'));
    });

    blocTest<RoadTaxCubit, RoadTaxState>(
      'yourCustomFunction emits nothing',
      build: RoadTaxCubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <RoadTaxState>[],
    );
  });
}
