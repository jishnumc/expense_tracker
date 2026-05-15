import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthOnboardingView extends StatefulWidget {
  final String phone;
  const AuthOnboardingView({super.key, required this.phone});

  @override
  State<AuthOnboardingView> createState() => _AuthOnboardingViewState();
}

class _AuthOnboardingViewState extends State<AuthOnboardingView> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameEmpty = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _isNameEmpty = _nameController.text.trim().isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (user) {
            context.go('/home');
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "👋 What should we call you?",
                  style: textTheme.headlineMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "This name stays only on your device.",
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.white.withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 60),
                ETTextField(
                  controller: _nameController,
                  hintText: 'Eg: Johnnnie',
                  suffixIcon: !_isNameEmpty
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 24,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ETPrimaryButton(
                      label: state.maybeWhen(
                        loading: () => 'Creating...',
                        orElse: () => 'Continue',
                      ),
                      onPressed: (_isNameEmpty || state is AuthLoading)
                          ? null
                          : () {
                              final nickname = _nameController.text.trim();
                              context.read<AuthBloc>().add(
                                AuthEvent.registerRequested(
                                  phone: widget.phone,
                                  nickname: nickname,
                                ),
                              );
                            },
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
