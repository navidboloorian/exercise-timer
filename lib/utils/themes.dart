import 'package:flutter/material.dart';

import 'colors.dart';

class Themes {
  // dark theme
  static ThemeData get dark {
    return ThemeData(
      primaryColor: CustomColors.darkBackground,
      scaffoldBackgroundColor: CustomColors.darkBackground,
      fontFamily: 'Montserrat',
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        bodyText2: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CustomColors.darkBackground,
        foregroundColor: CustomColors.darkText,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 30,
          fontWeight: FontWeight.w300,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
