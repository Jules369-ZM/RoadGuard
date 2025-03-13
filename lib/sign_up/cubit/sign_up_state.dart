part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.name = const Name.pure(),
    this.phone = const PhoneNumber.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.message = '',
    this.isValid = false,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final Name name;
  final PhoneNumber phone;
  final FormzSubmissionStatus status;
  final String message;
  final bool isValid;

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    Name? name,
    PhoneNumber? phone,
    FormzSubmissionStatus? status,
    String? message,
    bool? isValid,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      message: message ?? this.message,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
        confirmedPassword,
        name,
        phone,
        status,
        message,
        isValid,
      ];
}
