part of 'sign_up_cubit.dart';

/// {@template sign_up}
/// SignUpState description
/// {@endtemplate}
class SignUpState extends Equatable {
  /// {@macro sign_up}
  const SignUpState({
    this.message = 'Default Value',
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  /// A description for customProperty
  final String message;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final bool isValid;

  @override
  List<Object> get props =>
      [message, email, password, confirmedPassword, status, isValid];

  /// Creates a copy of the current SignUpState with property changes
  SignUpState copyWith({
    String? message,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return SignUpState(
      message: message ?? this.message,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }
}
