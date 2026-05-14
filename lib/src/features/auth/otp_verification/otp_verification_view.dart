import 'dart:async';

import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/app_ui/widgets/inputs/et_otp_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              "Verify OTP",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 24),
            ),
            Text(
              "Enter the 6-Digit code sent to 8606****23",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.zAppColors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),
            ETOtpField(),
            const SizedBox(height: 16),
            ETPrimaryButton(
              label: 'Verify',
              onPressed: () {
                context.go('/auth-onboarding');
              },
            ),
            const SizedBox(height: 36),
            Text(
              _secondsRemaining == 0
                  ? "Resend OTP"
                  : "Resend OTP in $_secondsRemaining",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
