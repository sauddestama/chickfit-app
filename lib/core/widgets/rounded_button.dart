import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? elevation;
  final double? roundValue;
  final VoidCallback? onTap;
  final bool disable;
  final BorderSide? borderSide;

  const RoundedButton(
      {Key? key,
      required this.text,
      this.backgroundColor,
      this.textColor,
      this.padding,
      this.elevation,
      this.roundValue,
      this.onTap,
      this.disable = false,
      this.borderSide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(roundValue ?? 18.0),
          ),
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: elevation ?? 4,
          foregroundColor: !disable
              ? backgroundColor ?? AssetColors.backgroundGrey
              : Colors.grey,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: !disable ? textColor : Colors.white,
          ),
        ));
  }
}
