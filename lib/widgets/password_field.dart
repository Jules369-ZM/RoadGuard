import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
    this._controller, {
    super.key,
    this.label = 'Password',
    this.error,
  });

  final TextEditingController _controller;
  final String label;
  final String? error;

  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _hidePassword,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return null;
        }
        return widget.error ?? 'Password is required';
      },
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 24,
        ),
        suffixIcon: IconButton(
          splashRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            _hidePassword ? Icons.visibility : Icons.visibility_off,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
        ),
      ),
    );
  }
}
