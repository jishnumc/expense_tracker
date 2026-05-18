import 'package:flutter/material.dart';

/// {@template app_colors}
/// The color palette for the application, extending [ThemeExtension].
/// Contains core Material 3 colors, excluding rarely used variants.
/// {@endtemplate}
class AppColors extends ThemeExtension<AppColors> {
  /// {@macro app_colors}
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.error,
    required this.onError,
    required this.success,
    required this.onSuccess,
    required this.incomePrimary,
    required this.incomeSecondary,
    required this.expensePrimary,
    required this.expenseSecondary,
    required this.surface,
    required this.onSurface,
    required this.outline,
    required this.white,
    required this.foundationBlack,
  });

  /// The primary color.
  final Color primary;

  /// The on-primary color.
  final Color onPrimary;

  /// The primary container color.
  final Color primaryContainer;

  /// The on-primary container color.
  final Color onPrimaryContainer;

  /// The secondary color.
  final Color secondary;

  /// The on-secondary color.
  final Color onSecondary;

  /// The secondary container color.
  final Color secondaryContainer;

  /// The on-secondary container color.
  final Color onSecondaryContainer;

  /// The error color.
  final Color error;

  /// The on-error color.
  final Color onError;

  /// The success color.
  final Color success;

  /// The on-success color.
  final Color onSuccess;

  /// The income primary color.
  final Color incomePrimary;

  /// The income secondary color.
  final Color incomeSecondary;

  /// The expense primary color.
  final Color expensePrimary;

  /// The expense secondary color.
  final Color expenseSecondary;

  /// The surface color.
  final Color surface;

  /// The on-surface color.
  final Color onSurface;

  /// The outline color.
  final Color outline;

  /// The white color.
  final Color white;

  /// The foundation black color.
  final Color foundationBlack;

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? error,
    Color? onError,
    Color? success,
    Color? onSuccess,
    Color? incomePrimary,
    Color? incomeSecondary,
    Color? expensePrimary,
    Color? expenseSecondary,
    Color? surface,
    Color? onSurface,
    Color? outline,
    Color? white,
    Color? foundationBlack,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      incomePrimary: incomePrimary ?? this.incomePrimary,
      incomeSecondary: incomeSecondary ?? this.incomeSecondary,
      expensePrimary: expensePrimary ?? this.expensePrimary,
      expenseSecondary: expenseSecondary ?? this.expenseSecondary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      outline: outline ?? this.outline,
      white: white ?? this.white,
      foundationBlack: foundationBlack ?? this.foundationBlack,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      secondaryContainer: Color.lerp(
        secondaryContainer,
        other.secondaryContainer,
        t,
      )!,
      onSecondaryContainer: Color.lerp(
        onSecondaryContainer,
        other.onSecondaryContainer,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      incomePrimary: Color.lerp(incomePrimary, other.incomePrimary, t)!,
      incomeSecondary: Color.lerp(incomeSecondary, other.incomeSecondary, t)!,
      expensePrimary: Color.lerp(expensePrimary, other.expensePrimary, t)!,
      expenseSecondary: Color.lerp(
        expenseSecondary,
        other.expenseSecondary,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      white: Color.lerp(white, other.white, t)!,
      foundationBlack: Color.lerp(foundationBlack, other.foundationBlack, t)!,
    );
  }
}
