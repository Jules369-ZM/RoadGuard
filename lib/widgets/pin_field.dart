import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class PinField extends StatefulWidget {
  const PinField(
    this.controller, {
    super.key,
    this.length = 4,
    this.obscureText = false,
    this.separatorPositions,
    this.separator,
    this.onCompleted,
    this.validator,
  });

  final TextEditingController controller;
  final int length;
  final bool obscureText;
  final void Function(String)? onCompleted;
  final String? Function(String?)? validator;
  final List<int>? separatorPositions;
  final Widget? separator;

  @override
  PinFieldState createState() => PinFieldState();

  @override
  String toStringShort() => 'With Bottom Cursor';
}

class PinFieldState extends State<PinField> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 24,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );

    final cursor = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 3,
          ),
        ),
      ),
    );

    final preFilledWidget = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );

    return Pinput(
      length: widget.length,
      controller: widget.controller,
      obscureText: widget.obscureText,
      pinAnimationType: PinAnimationType.slide,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      cursor: cursor,
      preFilledWidget: preFilledWidget,
      onCompleted: widget.onCompleted,
      separatorBuilder: (pos) {
        if (widget.separatorPositions?.contains(pos) ?? true) {
          return widget.separator ?? const SizedBox(width: 8);
        }
        return const SizedBox.shrink();
      },
      validator: widget.validator,
    );
  }
}
