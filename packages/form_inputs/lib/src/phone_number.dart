import 'package:formz/formz.dart';

/// Validation errors for the [PhoneNumber] [FormzInput].
enum PhoneNumberValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template phone_number}
/// Form input for a phone number input.
/// {@endtemplate}
class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  /// {@macro phone_number}
  const PhoneNumber.pure() : super.pure('');

  /// {@macro phone_number}
  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  static final _phoneRegExp = RegExp(r'^\+?[1-9]\d{9,14}$');

  @override
  PhoneNumberValidationError? validator(String? value) {
    return _phoneRegExp.hasMatch(value ?? '')
        ? null
        : PhoneNumberValidationError.invalid;
  }
}
