import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ETPrimaryButton(
              label: 'CONTINUE',
              onPressed: () {
                debugPrint('Navigating to OTP Verification');
                context.go('/otp-verification');
              },
            ),
          ],
        ),
      ),
    );
  }
}
