import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:net_source/net_source.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.firebaseRepo, this.authRepo) : super(const AppState()) {
    // _authState = servicesRepo.authState.listen(
    //   (status) {
    //     if (status == 3) {
    //       authRepo.expired();
    //     }
    //   },
    // );
  }

  final FirebaseRepo firebaseRepo;
  final AuthRepo authRepo;

  late StreamSubscription<int> _authState;

  void initApp() => emit(const AppState());

  @override
  Future<void> close() {
    _authState.cancel();
    return super.close();
  }
}
