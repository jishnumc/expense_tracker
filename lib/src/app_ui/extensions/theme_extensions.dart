import 'package:flutter/material.dart';
import 'package:expense_tracker/src/app_ui/colors/app_colors.dart';
import 'package:expense_tracker/src/app_ui/colors/app_colors_dark.dart';
import 'package:expense_tracker/src/app_ui/colors/app_colors_light.dart';

// High contrast variants for the_app (stubbing out with light/dark for now or copying actual)

class AppColorsHighContrastDark extends AppColorsDark {
  const AppColorsHighContrastDark();
}

class AppColorsHighContrastLight extends AppColorsLight {
  const AppColorsHighContrastLight();
}

/// {@template app_theme_x}
/// Extensions on [BuildContext] to access the app theme.
/// {@endtemplate}
extension AppThemeX on BuildContext {
  /// Returns the [AppColors] extension from the current [Theme].
  ///
  /// Throws an error if [AppColors] is not found in the theme extensions.
  /// This ensures that the app always has access to the custom color palette.
  AppColors get zAppColors {
    final theme = Theme.of(this);
    final appColors = theme.extension<AppColors>();
    if (appColors == null) {
      throw FlutterError(
        'AppColors extension was not found in the current theme. '
        'Make sure to include AppColors in your ThemeData extensions.',
      );
    }
    return appColors;
  }

  /// Returns whether the current theme is in high contrast mode.
  ///
  /// This is determined by checking if the [ThemeData] contains specific
  /// high contrast color signatures or by system query if needed.
  /// For now, simpler access to colors is the priority.
  bool get zIsHighContrast {
    // Basic check could be improved based on specific flags if added to
    // AppColors
    return zAppColors is AppColorsHighContrastLight ||
        zAppColors is AppColorsHighContrastDark;
  }

  /// Returns the current [ThemeData].
  ThemeData get zTheme => Theme.of(this);

  /// Returns the current [TextTheme].
  TextTheme get zTextTheme => zTheme.textTheme;

  /// Returns the current [ColorScheme].
  ColorScheme get zColorScheme => zTheme.colorScheme;

  /// Returns whether the current theme is dark.
  bool get zIsDark => zTheme.brightness == Brightness.dark;

  /// Returns whether the current theme is light.
  bool get zIsLight => zTheme.brightness == Brightness.light;
}
