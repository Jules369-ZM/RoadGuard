import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this.firebaseRepo) : super(const SignUpState());
  final FirebaseRepo firebaseRepo;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        message: '',
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
          state.confirmedPassword,
          state.name,
          state.phone,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        message: '',
        password: password,
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.email,
          password,
          confirmedPassword,
          state.name,
          state.phone,
        ]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        message: '',
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.email,
          state.password,
          confirmedPassword,
          state.name,
          state.phone,
        ]),
      ),
    );
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(
      state.copyWith(
        name: name,
        message: '',
        isValid: Formz.validate([
          state.email,
          state.password,
          state.confirmedPassword,
          name,
          state.phone,
        ]),
      ),
    );
  }

  void phoneChanged(String value) {
    final phone = PhoneNumber.dirty(value);
    emit(
      state.copyWith(
        message: '',
        phone: phone,
        isValid: Formz.validate([
          state.email,
          state.password,
          state.confirmedPassword,
          state.name,
          phone,
        ]),
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await firebaseRepo.signUp(
        email: state.email.value,
        password: state.password.value,
        name: state.name.value,
        phone: state.phone.value,
        metaData: '',
        role: 'DRIVER',
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          message: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
