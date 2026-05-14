import 'package:expense_tracker/src/app_ui/colors/app_colors.dart';
import 'package:flutter/material.dart';

/// {@template app_colors_light}
/// The light theme color palette.
/// {@endtemplate}
class AppColorsLight extends AppColors {
  /// {@macro app_colors_light}
  const AppColorsLight()
    : super(
        primary: const Color(0xFF312ECB),
        onPrimary: const Color(0xFFFFFFFF),
        primaryContainer: const Color(0xFFEADDFF),
        onPrimaryContainer: const Color(0xFF21005D),
        secondary: const Color(0xFF625B71),
        onSecondary: const Color(0xFFFFFFFF),
        secondaryContainer: const Color(0xFFE8DEF8),
        onSecondaryContainer: const Color(0xFF1D192B),
        error: const Color(0xFFB3261E),
        onError: const Color(0xFFFFFFFF),
        surface: const Color(0xFFFFFBFE),
        onSurface: const Color(0xFF1C1B1F),
        outline: const Color(0xFF79747E),
      );
}
