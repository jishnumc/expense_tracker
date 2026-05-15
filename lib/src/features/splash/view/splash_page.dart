import 'package:expense_tracker/src/app_ui/assets.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (user) => context.go('/home'),
          initial: () => context.go('/onboarding'),
          error: (_) => context.go('/onboarding'),
          orElse: () {},
        );
      },
      child: Scaffold(
        body: Center(
          child: SvgPicture.asset(AppAssets.etLogo, width: 133, height: 104),
        ),
      ),
    );
  }
}
