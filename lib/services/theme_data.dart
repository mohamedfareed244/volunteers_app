import 'package:flutter/material.dart';

import 'app_colors.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme,
    required BuildContext context,
  }) {
    return ThemeData(
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
