import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors matching reference design
  static const Color primaryColor = Color(0xFF00695C); // Dark Teal
  static const Color primaryDark = Color(0xFF004D40);
  static const Color secondaryColor = Color(0xFF3C7885);
  static const Color backgroundColor = Colors.white;
  static const Color cardBackgroundColor = Colors.white;

  // Title / Body Text Color
  static const Color titleTextColor = Color(0xFF2C3E50);
  static const Color subtitleTextColor = Color(0xFF8E9BAE);

  // Feedback Colors
  static const Color correctColor = Color(0xFF2E7D32);
  static const Color correctBackground = Color(0xFFE8F5E9);
  static const Color wrongColor = Color(0xFFD32F2F);
  static const Color wrongBackground = Color(0xFFFFEBEE);

  // Exact Hex Colors Extracted from Reference Screenshot Cards
  static const Color colorGeneralKnowledge = Color(0xFFC0D1FD); // Soft Blue
  static const Color colorBooks = Color(0xFFC0FDCB); // Soft Green
  static const Color colorHistory = Color(0xFFFDFDC0); // Soft Yellow
  static const Color colorScience = Color(0xFFF1C0FD); // Soft Purple
  static const Color colorArt = Color(0xFFFDC0C1); // Soft Pink
  static const Color colorVehicles = Color(0xFFFDE4C0); // Soft Peach/Orange

  static const List<Color> categoryColors = [
    colorGeneralKnowledge,
    colorBooks,
    colorHistory,
    colorScience,
    colorArt,
    colorVehicles,
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardBackgroundColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: titleTextColor),
        titleTextStyle: TextStyle(
          color: titleTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xFF00A8FF),
        inactiveTrackColor: const Color(0xFFE2E8F0),
        thumbColor: const Color(0xFF00A8FF),
        overlayColor: const Color(0xFF00A8FF).withValues(alpha: 0.12),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
