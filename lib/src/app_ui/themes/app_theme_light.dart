import 'package:expense_tracker/src/app_ui/typograhy/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/app_ui/colors/app_colors_light.dart';
import 'package:expense_tracker/src/app_ui/themes/app_theme.dart';

/// {@template app_theme_light}
/// A light theme for the application.
///
/// This theme uses [AppColorsLight] and provides a bright, standard color
/// scheme.
/// {@endtemplate}

/// {@template light_app_theme}
/// The light theme implementation.
/// {@endtemplate}
class AppThemeLight extends AppTheme {
  /// {@macro light_app_theme}
  const AppThemeLight(AppTextTheme textTheme)
    : super(colors: const AppColorsLight(), textTheme: textTheme);

  @override
  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme.data,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        secondaryContainer: colors.secondaryContainer,
        onSecondaryContainer: colors.onSecondaryContainer,
        error: colors.error,
        onError: colors.onError,
        surface: colors.surface,
        onSurface: colors.onSurface,
        outline: colors.outline,
      ),
      extensions: [colors],
    );
  }
}
