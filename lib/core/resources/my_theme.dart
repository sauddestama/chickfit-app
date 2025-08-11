import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

final myTheme = ThemeData(
  fontFamily: 'Inter',
  primarySwatch: Colors.blueGrey,
  primaryColor: kPrimarySwacth.shade500,
  focusColor: kPrimarySwacth.shade600,
  appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
  inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AssetColors.goldColor.withOpacity(0.2),
      focusColor: AssetColors.blackBackground,
      enabledBorder: OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffBDC3D6), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AssetColors.blackText, width: 1.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffBDC3D6)),
        borderRadius: BorderRadius.circular(8),
      ),
      disabledBorder: OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffBDC3D6), width: 1.0),
      )),
  elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
  outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
);
final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
);
final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
