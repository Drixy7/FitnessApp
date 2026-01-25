import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  //TODO chooseFONT and remove dependency on internet by downloading font instead of using getters
  AppTextStyles._();

  // --- DISPLAY (Obří texty) ---
  static TextStyle get displayLarge =>
      GoogleFonts.roboto(fontSize: 57, fontWeight: FontWeight.bold);

  static TextStyle get displayMedium =>
      GoogleFonts.roboto(fontSize: 45, fontWeight: FontWeight.bold);

  // --- HEADLINE (Nadpisy obrazovek) ---
  static TextStyle get headlineLarge => GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.w600, // Semi-bold
  );

  static TextStyle get headlineMedium =>
      GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.w600);

  // --- TITLE (Nadpisy prvků/cviků) ---
  static TextStyle get titleLarge => GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w600, // Medium
  );

  static TextStyle get titleMedium => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  // --- BODY (Dlouhé texty) ---
  static TextStyle get bodyLarge => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
  );

  // --- LABEL (Tlačítka a popisky) ---
  static TextStyle get labelLarge => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.bold, // Tlačítka chtějí být výrazná
    letterSpacing: 0.1,
  );

  static TextStyle get labelSmall => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
