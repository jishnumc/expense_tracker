import 'package:expense_tracker/src/outer_layer/validation/validation_result.dart';
import 'package:expense_tracker/src/outer_layer/validation/validators/phone_validator.dart';
import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';

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
            ETSnackBar.show(
              context,
              message: message,
              type: ETSnackBarType.error,
            );
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  prefix: ETCountryCodePicker(
                    selectedCountryCode: _selectedCountryCode,
                    onChanged: (code) {
                      setState(() {
                        _selectedCountryCode = code;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final result = PhoneValidator().validate(value);
                    switch (result) {
                      case ValidationSuccess():
                        return null;
                      case ValidationFailure():
                        return result.error.message;
                    }
                  },
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
                          final localPhone = _phoneController.text.trim();
                          if (localPhone.isEmpty) {
                            ETSnackBar.show(
                              context,
                              message: 'Please enter your phone number',
                              type: ETSnackBarType.error,
                            );
                            return;
                          }

                          if (_formKey.currentState?.validate() ?? false) {
                            final phone = '$_selectedCountryCode$localPhone';
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
      ),
    );
  }
}
