import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme,
    required BuildContext context,
  }) {
    return ThemeData(
     // Setting up text themes with Google Fonts and fallback
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: TextStyle(
          color: isDarkTheme
              ? Colors.white // Text color in dark mode
              : Colors.black, // Text color in light mode
        ),
        bodyMedium: TextStyle(
          color: isDarkTheme
              ? const Color.fromARGB(179, 255, 255, 255) // Secondary text color in dark mode
              : Colors.black87, // Secondary text color in light mode
        ),
        titleLarge: TextStyle(
          color: isDarkTheme
              ? Colors.white // Headline color in dark mode
              : Colors.black, // Headline color in light mode
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      scaffoldBackgroundColor: isDarkTheme
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,
      cardColor: isDarkTheme
          ? const Color.fromARGB(255, 13, 6, 37)
          : const Color.fromARGB(255, 255, 152, 0),
           primaryColorLight: isDarkTheme
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 0, 0, 0),
            canvasColor: isDarkTheme
          ? const Color.fromARGB(255, 0, 0, 0)
          : const Color.fromARGB(255, 238, 238, 238),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    );
  }
}
