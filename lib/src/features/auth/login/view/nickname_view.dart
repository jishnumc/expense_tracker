import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NicknameView extends StatefulWidget {
  final String phone;

  const NicknameView({super.key, required this.phone});

  @override
  State<NicknameView> createState() => _NicknameViewState();
}

class _NicknameViewState extends State<NicknameView> {
  final _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
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
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
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
                "Create Profile",
                style: Theme.of(context).textTheme.headlineLarge
                    ?.copyWith(color: context.zAppColors.white)
                    .copyWith(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Text(
                "Enter a nickname to continue",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
              ETTextField(
                controller: _nicknameController,
                hintText: 'Nickname',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ETPrimaryButton(
                    label: state.maybeWhen(
                      loading: () => 'CREATING...',
                      orElse: () => 'FINISH',
                    ),
                    onPressed: state.maybeWhen(
                      loading: () => null,
                      orElse: () => () {
                        final nickname = _nicknameController.text.trim();
                        if (nickname.isNotEmpty) {
                          context.read<AuthBloc>().add(
                                AuthEvent.registerRequested(
                                  phone: widget.phone,
                                  nickname: nickname,
                                ),
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
