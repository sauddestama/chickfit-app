import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String text;

  final Color? textColor;
  final Color? backgroundColor;
  final double? verticalPadding;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPress,
    this.textColor,
    this.backgroundColor,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          minimumSize: Size.zero,
          // primary: backgroundColor ?? Colors.white,
          // onSurface: backgroundColor ?? Colors.white,
          padding: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPress,
        child: Text(
          text,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
            color: textColor ?? AssetColors.colorPrimaryDark,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
    );
  }
}
