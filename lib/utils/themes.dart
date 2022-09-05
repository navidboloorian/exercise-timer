import 'package:flutter/material.dart';

import 'colors.dart';

class Themes {
  // dark theme
  static ThemeData get dark {
    return ThemeData(
      primaryColor: CustomColors.darkBackground,
      scaffoldBackgroundColor: CustomColors.darkBackground,
      fontFamily: 'Montserrat',
      appBarTheme: const AppBarTheme(
        backgroundColor: CustomColors.darkBackground,
        foregroundColor: CustomColors.darkText,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 50,
          fontWeight: FontWeight.w300,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
