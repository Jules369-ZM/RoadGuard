import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:road_guard/sign_up/cubit/cubit.dart';
import 'package:road_guard/utils/utils.dart';
import 'package:road_guard/widgets/widgets.dart';

/// {@template sign_up_body}
/// Body of the SignUpPage.
/// {@endtemplate}
class SignUpBody extends StatelessWidget {
  /// {@macro sign_up_body}
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          if (state.message.isEmpty) return;
          showErrorSnackBar(context, message: state.message);
        }
        if (state.status == FormzSubmissionStatus.success) {
          showSuccessSnackBar(context, message: 'Sign Up successful');
        }
      },
      builder: (context, state) {
        return Align(
          alignment: const Alignment(0, -1 / 3),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NameInput(),
                SizedBox(height: getProportionateScreenHeight(8)),
                _PhoneInput(),
                SizedBox(height: getProportionateScreenHeight(8)),
                _EmailInput(),
                SizedBox(height: getProportionateScreenHeight(8)),
                _PasswordInput(),
                SizedBox(height: getProportionateScreenHeight(8)),
                _ConfirmPasswordInput(),
                SizedBox(height: getProportionateScreenHeight(8)),
                _SignUpButton(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.name.displayError,
    );

    return TextField(
      key: const Key('signUpForm_nameInput_textField'),
      onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Full Name',
        helperText: '',
        errorText: displayError != null ? 'Invalid name' : null,
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.phone.displayError,
    );

    return TextField(
      key: const Key('signUpForm_phoneInput_textField'),
      onChanged: (phone) => context.read<SignUpCubit>().phoneChanged(phone),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        helperText: '',
        errorText: displayError != null ? 'Invalid phone number' : null,
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.email.displayError,
    );

    return TextField(
      key: const Key('signUpForm_emailInput_textField'),
      onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        helperText: '',
        errorText: displayError != null ? 'Invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.password.displayError,
    );

    return TextField(
      key: const Key('signUpForm_passwordInput_textField'),
      onChanged: (password) =>
          context.read<SignUpCubit>().passwordChanged(password),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        helperText: '',
        errorText: displayError != null ? 'Invalid password' : null,
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.confirmedPassword.displayError,
    );

    return TextField(
      key: const Key('signUpForm_confirmedPasswordInput_textField'),
      onChanged: (confirmPassword) =>
          context.read<SignUpCubit>().confirmedPasswordChanged(confirmPassword),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        helperText: '',
        errorText: displayError != null ? 'Passwords do not match' : null,
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({required this.state});

  final SignUpState state;

  @override
  Widget build(BuildContext context) {
    final isInProgress = state.status == FormzSubmissionStatus.inProgress;
    final isValid = context.select(
      (SignUpCubit cubit) => cubit.state.isValid,
    );

    return AppButton(
      loading: isInProgress,
      key: const Key('signUpForm_continue_raisedButton'),
      onPressed: isValid
          ? () => context.read<SignUpCubit>().signUpFormSubmitted()
          : null,
      text: 'SIGN UP',
    );
  }
}
