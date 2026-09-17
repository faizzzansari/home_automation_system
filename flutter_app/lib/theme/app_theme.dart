import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color accentColor = Color(0xFF6366F1);
  static const Color bluetoothColor = Color(0xFF0EA5E9);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightSubText = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkSubText = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBg,
    colorScheme: const ColorScheme.light(
      primary: accentColor,
      secondary: bluetoothColor,
      surface: lightSurface,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightText,
      onError: Colors.white,
      outline: lightBorder,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightSurface,
      surfaceTintColor: lightSurface,
      elevation: 0,
      foregroundColor: lightText,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: lightText,
      ),
    ),
    cardColor: lightSurface,
    dividerColor: lightBorder,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentColor;
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor.withOpacity(0.35);
        }
        return lightSubText.withOpacity(0.25);
      }),
    ),
    textTheme: _textTheme(lightText, lightSubText),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: bluetoothColor,
      surface: darkSurface,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkText,
      onError: Colors.white,
      outline: darkBorder,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      surfaceTintColor: darkSurface,
      elevation: 0,
      foregroundColor: darkText,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: darkText,
      ),
    ),
    cardColor: darkSurface,
    dividerColor: darkBorder,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentColor;
        return darkSubText;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor.withOpacity(0.35);
        }
        return darkSubText.withOpacity(0.25);
      }),
    ),
    textTheme: _textTheme(darkText, darkSubText),
  );

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
    );
  }
}
