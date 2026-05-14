import 'package:expense_tracker/src/app_ui/colors/app_colors.dart';
import 'package:expense_tracker/src/app_ui/typograhy/app_text_theme.dart';
import 'package:flutter/material.dart';

/// {@template app_theme}
/// The base theme for the application.
/// {@endtemplate}
abstract class AppTheme {
  /// {@macro app_theme}
  const AppTheme({required this.colors, required this.textTheme});

  /// The colors for this theme.
  final AppColors colors;

  /// The text theme for this theme.
  final AppTextTheme textTheme;

  /// Returns the [ThemeData] for this theme.
  ThemeData get themeData;
}
