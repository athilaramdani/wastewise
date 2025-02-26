import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warna hijau utama
  static Color primaryGreen = const Color(0xFF4CAF50);

  // Variasi warna hijau lain
  static Color greenLight = const Color(0xFF66BB6A);
  static Color greenDark = const Color(0xFF388E3C);
  static Color greenAccent = const Color(0xFFA5D6A7);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryGreen,
      secondary: greenLight,
    ),
    // Warna Switch saat aktif (untuk Light Mode)
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
            (states) => primaryGreen,
      ),
      trackColor: WidgetStateProperty.resolveWith(
            (states) => greenAccent.withOpacity(0.5),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryGreen,
      secondary: greenLight,
    ),
    // Warna Switch saat aktif (untuk Dark Mode)
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
            (states) => primaryGreen,
      ),
      trackColor: WidgetStateProperty.resolveWith(
            (states) => greenAccent.withOpacity(0.3),
      ),
    ),
  );
}
