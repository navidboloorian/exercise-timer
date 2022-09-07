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
        subtitle1: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
          fontSize: 20,
        ),
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
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
          fontSize: 20,
        ),
        isDense: true,
        alignLabelWithHint: true,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: TextStyle(color: Colors.white),
        floatingLabelStyle: TextStyle(height: 0),
        counterStyle: TextStyle(height: 0),
        contentPadding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
        // constraints: BoxConstraints(minHeight: 30, maxHeight: 35),
      ),
    );
  }
}
