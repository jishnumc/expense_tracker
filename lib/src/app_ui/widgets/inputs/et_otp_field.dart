import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ETOtpField extends StatelessWidget {
  const ETOtpField({
    this.controller,
    this.onCompleted,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    final defaultPinTheme = PinTheme(
      width: 52,
      height: 64,
      textStyle: textTheme.headlineSmall?.copyWith(
        color: colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Pinput(
      length: 6,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      controller: controller,
      onCompleted: onCompleted,
      onChanged: onChanged,
      defaultPinTheme: defaultPinTheme,
      preFilledWidget: Text(
        '-',
        style: textTheme.headlineSmall?.copyWith(
          color: colors.white.withValues(alpha: 0.2),
        ),
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: colors.primary.withValues(alpha: 0.5)),
        ),
      ),
      submittedPinTheme: defaultPinTheme,
    );
  }
}
