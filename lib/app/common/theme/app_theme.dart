import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warna hijau utama
  static Color primaryGreen = const Color(0xFF4CAF50);

  // Tambahan warna hijau untuk gradient
  static Color greenLight = const Color(0xFF66BB6A);
  static Color greenDark = const Color(0xFF388E3C);

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
      secondary: primaryGreen,
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
      secondary: primaryGreen,
    ),
  );
}
