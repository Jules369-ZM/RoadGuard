import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.repo, this.firebaseRepo) : super(const AuthState()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    // firebaseRepo.listenForUser();

    _authStatusSubscription = repo.status.listen(
      (status) => add(
        AuthStatusChanged(status),
      ),
    );
    // _serviceStatusSubscription = firebaseRepo.authState.listen(
    // (status) {
    // if (status == 700) {
    // repo.logOut();
    // add(
    // const AuthStatusChanged(AuthStatus.expired),
    // ); // 700 is the status code for expired token
    // }
    // },
    // );
  }

  final AuthRepo repo;
  final FirebaseRepo firebaseRepo;
  late StreamSubscription<AuthStatus> _authStatusSubscription;
  // late StreamSubscription<int> _serviceStatusSubscription;

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    // _serviceStatusSubscription.cancel();
    repo.dispose();
    return super.close();
  }

  bool first = true;
  Future<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    final status = event.status;
    final user = await _tryGetUser();
    final appVersion = await repo.getAppVersion(); // get app version
    if (user == null && first) {
      // final res = await repo.queryDeviceActivation();
      // if (res.message.toLowerCase() == 'Device not found'.toLowerCase()) {
      // repo.unRegisterDevice();
      // status = AuthStatus.unregisteredDevice;
      // first = false;
      // } else {
      // status = AuthStatus.unauthenticated; // if user is not authenticated
      // }
    } else {
      // status = AuthStatus.authenticated; // if user is  authenticated
    }
    // status = AuthStatus.guest;
    return emit(
      state.copyWith(
        status: status,
        user: user,
        appVersion: appVersion,
      ),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repo.logOut();
    add(const AuthStatusChanged(AuthStatus.unauthenticated));
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await repo.getUser();
      // log('user1: ${user?.toJson()}');
      return user;
    } catch (_) {
      return null;
    }
  }
}
