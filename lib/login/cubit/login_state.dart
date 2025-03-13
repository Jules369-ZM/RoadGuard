part of 'login_cubit.dart';

/// {@template login}
/// LoginState description
/// {@endtemplate}
class LoginState extends Equatable {
  /// {@macro login}
  const LoginState({
    this.message = 'Default Value',
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  /// A description for message
  final String message;
  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;

  @override
  List<Object> get props => [message, email, password, status, isValid];

  /// Creates a copy of the current LoginState with property changes
  LoginState copyWith({
    String? message,
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return LoginState(
      message: message ?? this.message,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }
}
