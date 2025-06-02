import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:road_guard/utils/constants.dart';
import 'package:road_guard/utils/enums.dart';
part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit(this.firebaseRepo) : super(const MainState());
  final FirebaseRepo firebaseRepo;

  /// A description for yourCustomFunction
  Future<void> sendToken(String token, User user) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: CurrentStatus.loading));
      await firebaseRepo.addDocument(
        {
          'token': token,
          'id': user.id,
          'email': user.email,
          'name': user.name,
          'phone': user.phone,
          'fullPhone': user.fullPhone,
          'countryCode': user.countryCode,
        },
        tokens,
        user.id!,
      );
      if (isClosed) return;
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          message: e.toString(),
          status: CurrentStatus.error,
        ),
      );
    }
  }

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
