import 'package:expense_tracker/src/features/auth/auth_onboarding/auth_onboarding_view.dart';
import 'package:expense_tracker/src/features/auth/login/view/login_view.dart';
import 'package:expense_tracker/src/features/auth/otp_verification/otp_verification_view.dart';
import 'package:expense_tracker/src/features/home/view/home_view.dart';
import 'package:expense_tracker/src/features/main/view/main_shell.dart';
import 'package:expense_tracker/src/features/onboarding/view/onboarding_page.dart';
import 'package:expense_tracker/src/features/profile/view/profile_view.dart';

import 'package:expense_tracker/src/features/splash/view/splash_page.dart';
import 'package:expense_tracker/src/features/transaction/view/add_transaction_sheet.dart';
import 'package:expense_tracker/src/features/transaction/view/transaction_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomSheetPage<T> extends Page<T> {
  const BottomSheetPage({required this.child, super.key});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      builder: (context) => child,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/add-transaction',
        pageBuilder: (context, state) =>
            const BottomSheetPage(child: AddTransactionSheet()),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),

      GoRoute(
        path: '/otp-verification',
        builder: (context, state) => const OtpVerificationView(),
      ),
      GoRoute(
        path: '/nickname',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return AuthOnboardingView(phone: phone);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
