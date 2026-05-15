import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (user) {
            context.go('/home');
          },
          otpSent: (phone, otp, userExists, nickname, token) {
            context.go('/otp-verification');
          },
          error: (message) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Get Started",
                style: Theme.of(context).textTheme.headlineLarge
                    ?.copyWith(color: context.zAppColors.white)
                    .copyWith(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Text(
                "Log In Using Phone & OTP",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
              ETTextField(
                controller: _phoneController,
                hintText: 'Phone',
                keyboardType: TextInputType.phone,
                prefix: Text(
                  '+91',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.zAppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ETPrimaryButton(
                    label: state.maybeWhen(
                      loading: () => 'SENDING...',
                      orElse: () => 'CONTINUE',
                    ),
                    onPressed: state.maybeWhen(
                      loading: () => null,
                      orElse: () => () {
                        final phone = _phoneController.text.trim();
                        if (phone.isNotEmpty) {
                          context.read<AuthBloc>().add(
                            AuthEvent.sendOtpRequested(phone),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
