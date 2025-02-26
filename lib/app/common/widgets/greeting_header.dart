import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GreetingHeader extends StatelessWidget {
  final String userName;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const GreetingHeader({
    Key? key,
    required this.userName,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Teks "Hello, <username>"
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, $userName",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Kelola sampah dengan bijak",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        // Switch Dark/Light Mode
        Switch(
          value: isDarkMode,
          onChanged: onThemeChanged,
        ),
      ],
    );
  }
}
