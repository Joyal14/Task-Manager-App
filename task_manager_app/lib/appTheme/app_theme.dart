import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/res/app_colors.dart';
import 'package:flutter_base/res/fonts.dart';

import 'global.dart' as globals;

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: Fonts.fontPoppins,
    brightness: Brightness.light,
    //  systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.orange),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: AppColors.white),
    appBarTheme: const AppBarTheme(
      color: AppColors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: globals.fontSize + 4,
          fontWeight: FontWeight.bold,
          color: Colors.blue),
      displayMedium: TextStyle(
          fontSize: globals.fontSize + 2, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: globals.fontSize, fontFamily: 'Hind'),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.black,
    brightness: Brightness.dark,
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: AppColors.black),
    fontFamily: Fonts.fontPoppins,
    appBarTheme: const AppBarTheme(
      color: AppColors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: globals.fontSize + 4,
          fontWeight: FontWeight.bold,
          color: Colors.red),
      displayMedium: TextStyle(
          fontSize: globals.fontSize + 2, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: globals.fontSize + 0, fontFamily: 'Hind'),
    ),
  );
}
