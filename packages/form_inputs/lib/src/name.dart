import 'package:formz/formz.dart';

/// Validation errors for the [Name] [FormzInput].
enum NameValidationError {
  /// Generic invalid error.
  invalid
}

/// Form input for a name input field.
class Name extends FormzInput<String, NameValidationError> {
  /// Pure constructor (for unmodified state)
  const Name.pure() : super.pure('');

  /// Dirty constructor (for modified state)
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    return (value != null && value.trim().isNotEmpty && value.length >= 2)
        ? null
        : NameValidationError.invalid;
  }
}
