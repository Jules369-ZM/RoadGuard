import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  /// A description for yourCustomFunction
  FutureOr<void> yourCustomFunction() {
  }

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
