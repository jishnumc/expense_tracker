import 'dart:async';
import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  int _secondsRemaining = 30;
  Timer? _timer;
  final _otpController = TextEditingController();

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
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (user) {
            context.go('/home');
          },
          nicknameRequired: (phone) {
            context.go('/nickname', extra: phone);
          },
          error: (message) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final phone = state.maybeWhen(
          otpSent: (phone, _, __, ___, ____) => phone,
          orElse: () => '',
        );
        final otp = state.maybeWhen(
          otpSent: (_, otp, __, ___, ____) => otp,
          orElse: () => '',
        );
        final userExists = state.maybeWhen(
          otpSent: (_, __, exists, ___, ____) => exists,
          orElse: () => false,
        );
        final nickname = state.maybeWhen(
          otpSent: (_, __, ___, nick, ____) => nick,
          orElse: () => null,
        );
        final token = state.maybeWhen(
          otpSent: (_, __, ___, ____, t) => t,
          orElse: () => null,
        );

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
                  "Enter the 6-Digit code sent to $phone",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.zAppColors.white,
                    fontSize: 15,
                  ),
                ),
                if (otp.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Test OTP: $otp",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ETOtpField(controller: _otpController),
                const SizedBox(height: 16),
                ETPrimaryButton(
                  label: state.maybeWhen(
                    loading: () => 'VERIFYING...',
                    orElse: () => 'Verify',
                  ),
                  onPressed: state.maybeWhen(
                    loading: () => null,
                    orElse: () => () {
                      final enteredOtp = _otpController.text;
                      if (enteredOtp.length == 6) {
                        context.read<AuthBloc>().add(
                          AuthEvent.verifyOtpRequested(
                            phone: phone,
                            otp: enteredOtp,
                            userExists: userExists,
                            nickname: nickname,
                            token: token,
                          ),
                        );
                      }
                    },
                  ),
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
      },
    );
  }
}
