import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Password is too short (less than 8 characters).
  tooShort,

  /// Password does not contain at least one digit.
  noNumber,

  /// Password does not contain at least one special character.
  noSpecialCharacter
}

/// {@template password}
/// Form input for a password field.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  static final _digitRegExp = RegExp('[0-9]');
  static final _specialCharRegExp = RegExp(r'[!@#$%^&*]');

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return PasswordValidationError.tooShort;
    if (value.length < 8) return PasswordValidationError.tooShort;
    if (!_digitRegExp.hasMatch(value)) return PasswordValidationError.noNumber;
    if (!_specialCharRegExp.hasMatch(value)) {
      return PasswordValidationError.noSpecialCharacter;
    }
    return null;
  }
}
