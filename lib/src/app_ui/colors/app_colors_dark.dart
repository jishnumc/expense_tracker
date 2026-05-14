import 'package:flutter/material.dart';

import 'package:expense_tracker/src/app_ui/colors/app_colors.dart';

/// {@template app_colors_dark}
/// The dark theme color palette.
/// {@endtemplate}
class AppColorsDark extends AppColors {
  /// {@macro app_colors_dark}
  const AppColorsDark()
    : super(
        primary: const Color(0xFF312ECB),
        onPrimary: const Color(0xFF381E72),
        primaryContainer: const Color(0xFF4F378B),
        onPrimaryContainer: const Color(0xFFEADDFF),
        secondary: const Color(0xFFCCC2DC),
        onSecondary: const Color(0xFF332D41),
        secondaryContainer: const Color(0xFF4A4458),
        onSecondaryContainer: const Color(0xFFE8DEF8),
        error: const Color(0xFFF2B8B5),
        onError: const Color(0xFF601410),
        surface: const Color(0xFF1C1B1F),
        onSurface: const Color(0xFFE6E1E5),
        outline: const Color(0xFF938F99),
      );
}
