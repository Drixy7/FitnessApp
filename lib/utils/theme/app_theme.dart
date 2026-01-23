import 'package:fitness_app/utils/theme/schemes/blue_scheme.dart';
import 'package:fitness_app/utils/theme/schemes/pink_scheme.dart';
import 'package:flutter/material.dart';

import 'app_text_styles.dart';

class AppTheme {
  static ThemeData _createTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: colorScheme.onSurface,
        ),

        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: colorScheme.onSurface,
        ),

        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: colorScheme.onSurface,
        ),

        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurface,
        ),

        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData getBlueLight() => _createTheme(BlueTheme.lightScheme());
  static ThemeData getBlueDark() => _createTheme(BlueTheme.darkScheme());
  static ThemeData getPinkLight() => _createTheme(PinkTheme.lightScheme());
  static ThemeData getPinkDark() => _createTheme(PinkTheme.darkScheme());
}
