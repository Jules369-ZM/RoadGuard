import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.firebaseRepo) : super(const LoginState());
  final FirebaseRepo firebaseRepo;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    if (isClosed) return;
    emit(
      state.copyWith(
        message: '',
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void test() {
    firebaseRepo.saveUserDataToFirestore(
      user: {
        'id': '1',
        'name': 'name',
        'email': 'email',
        'phone': 'phone',
        'metaData': 'metaData',
        'role': 'role',
        'avatar': 'avatar',
      },
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    if (isClosed) return;
    emit(
      state.copyWith(
        message: '',
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await firebaseRepo.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      if (isClosed) return;
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      log('Error in logInWithEmailAndPassword: ${e.message}');
      if (isClosed) return;
      emit(
        state.copyWith(
          message: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (e) {
      // log('Error in logInWithEmailAndPassword 1: $e');
      if (isClosed) return;
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> logInWithGoogle() async {
    if (isClosed) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await firebaseRepo.logInWithGoogle();
      if (isClosed) return;
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleFailure catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          message: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
