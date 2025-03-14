import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:road_guard/login/cubit/cubit.dart';
import 'package:road_guard/sign_up/sign_up.dart';
import 'package:road_guard/utils/size_config.dart';
import 'package:road_guard/widgets/widgets.dart';

/// {@template login_body}
/// Body of the LoginPage.
///
/// Add what it does
/// {@endtemplate}
class LoginBody extends StatelessWidget {
  /// {@macro login_body}
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          if (state.message.isEmpty) return;
          showErrorSnackBar(context, message: state.message);
        }
        if (state.status == FormzSubmissionStatus.success) {
          showSuccessSnackBar(context, message: 'Login successful');
        }
      },
      builder: (context, state) {
        return Align(
          alignment: const Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset(
                // 'assets/bloc_logo_small.png',
                // height: 120,
                // ),
                SizedBox(height: getProportionateScreenHeight(16)),
                _EmailInput(),
                SizedBox(height: getProportionateScreenHeight(8)),
                _PasswordInput(),
                SizedBox(height: getProportionateScreenHeight(8)),
                _LoginButton(state: state),
                SizedBox(height: getProportionateScreenHeight(16)),
                _GoogleLoginButton(state: state),
                const SizedBox(height: 4),
                _SignUpButton(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.email.displayError,
    );

    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'email',
        helperText: '',
        errorText: displayError != null ? 'invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.password.displayError,
    );

    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) =>
          context.read<LoginCubit>().passwordChanged(password),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'password',
        helperText: '',
        errorText: displayError != null ? 'invalid password' : null,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.state});

  final LoginState state;
  @override
  Widget build(BuildContext context) {
    final isInProgress = state.status == FormzSubmissionStatus.inProgress;

    // if (isInProgress) return const CircularProgressIndicator();

    final isValid = context.select(
      (LoginCubit cubit) => cubit.state.isValid,
    );

    return AppButton(
      key: const Key('loginForm_continue_raisedButton'),
      loading: isInProgress,
      text: 'LOGIN',
      onPressed: isValid
          ? () => context.read<LoginCubit>().logInWithCredentials()
          : null,
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton({required this.state});

  final LoginState state;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const size = Size.fromHeight(56);
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: size,
        shape: shape,
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({required this.state});

  final LoginState state;
  @override
  Widget build(BuildContext context) {
    return AppButton(
      key: const Key('loginForm_createAccount_flatButton'),
      // onPressed: () => context.read<LoginCubit>().test(),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      text: 'CREATE ACCOUNT',
      type: ButtonType.text,
      icon: null,
    );
  }
}
