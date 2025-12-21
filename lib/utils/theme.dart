import 'package:flutter/material.dart';

// A class to hold all our text style definitions
class AppTextStyles {
  // Private constructor to prevent anyone from instantiating this class
  AppTextStyles._();

  // Style for main titles on cards or sections
  static const TextStyle cardTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 1.5,
    color: Colors.black87, // It's good practice to define colors too
  );

  static const TextStyle description = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle pageMainTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
  static const TextStyle pageSubTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  // Style for standard list item titles
  static const TextStyle listTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Style for subtitles in list items
  static const TextStyle listSubtitle = TextStyle(
    fontSize: 14,
    color: Colors.grey, // A softer color for less important text
  );
}

class AppTheme {
  AppTheme._(); // Private constructor

  static final ThemeData mainTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
    useMaterial3: true,
    // You can even define default text themes here
    textTheme: const TextTheme(titleMedium: AppTextStyles.listTitle),
  );
}
