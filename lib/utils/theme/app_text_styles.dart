import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  //TODO chooseFONT and remove dependency on internet by downloading font instead of using getters
  AppTextStyles._();

  // --- DISPLAY (Obří texty) ---
  static TextStyle get displayLarge => GoogleFonts.roboto(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.roboto(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // --- HEADLINE (Nadpisy obrazovek) ---
  static TextStyle get headlineLarge => GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.roboto(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // --- TITLE (Nadpisy prvků/cviků) ---
  static TextStyle get titleLarge => GoogleFonts.roboto(
    fontSize: 22,
    fontWeight: FontWeight.w600, // Medium
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  // --- BODY (Dlouhé texty) ---
  static TextStyle get bodyLarge => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: AppColors.textSecondary, // Často bývá šedší
  );

  // --- LABEL (Tlačítka a popisky) ---
  static TextStyle get labelLarge => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.bold, // Tlačítka chtějí být výrazná
    letterSpacing: 0.1,
    color: AppColors.primary,
  );

  static TextStyle get labelSmall => GoogleFonts.roboto(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );
}
