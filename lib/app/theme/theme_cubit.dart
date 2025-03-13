import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';


class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._repo) : super(const ThemeState()) {
    getTheme();
  }

  final AuthRepo _repo;

  FutureOr<void> getTheme() async {
    final index = await _repo.getTheme();
    emit(state.copyWith(mode: ThemeMode.values[index]));
  }

  FutureOr<void> setTheme(int index) {
    _repo.setTheme(index);
    emit(state.copyWith(mode: ThemeMode.values[index]));
  }
}
