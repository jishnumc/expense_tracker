import 'package:expense_tracker/src/app_ui/typograhy/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/app_ui/colors/app_colors_dark.dart';
import 'package:expense_tracker/src/app_ui/themes/app_theme.dart';

/// {@template app_theme_dark}
/// A dark theme for the application.
///
/// This theme uses [AppColorsDark] and provides a dark color scheme
/// suitable for low-light environments.
/// {@endtemplate}

/// {@template dark_app_theme}
/// The dark theme implementation.
/// {@endtemplate}
class AppThemeDark extends AppTheme {
  /// {@macro dark_app_theme}
  const AppThemeDark(AppTextTheme textTheme)
    : super(colors: const AppColorsDark(), textTheme: textTheme);

  @override
  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
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
        brightness: Brightness.dark,
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
