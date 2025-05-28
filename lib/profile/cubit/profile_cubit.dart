import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/utils/constants.dart';
import 'package:road_guard/utils/enums.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.firebaseRepo) : super(const ProfileState());
  final FirebaseRepo firebaseRepo;

  Future<void> updateUser(
    Map<String, dynamic> data,
    User user,
  ) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: CurrentStatus.loading));

      await firebaseRepo.updateDocument(
        collectionPath: usersDoc,
        id: user.id!,
        data: data,
      );
      if (isClosed) return;
      await firebaseRepo.getUserById(user.id!, usersDoc);
      emit(
        state.copyWith(
          message: 'Updated successfully',
          status: CurrentStatus.success,
        ),
      );
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
}
