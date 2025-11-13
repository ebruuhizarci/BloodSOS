import 'package:flutter/material.dart';

const Color primaryColor = Color(0xfffb4458);
const Color secondaryColor = Color(0xffe1051c);
const double defaultPagePadding = 24.0;

const MaterialColor primaryMaterialColor = MaterialColor(0xfffb4458, {
  50: Color(0xffffe5e9),
  100: Color(0xffffccd4),
  200: Color(0xffff99aa),
  300: Color(0xffff667f),
  400: Color(0xffff3355),
  500: Color(0xfffb4458),
  600: Color(0xffc93746),
  700: Color(0xff972a35),
  800: Color(0xff641d23),
  900: Color(0xff320f12),
});

final ThemeData bloodSosAppTheme = ThemeData(
  primaryColor: primaryColor,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  primarySwatch: primaryMaterialColor,
  scaffoldBackgroundColor: const Color(0xFFF8F2FA),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  ),
);
