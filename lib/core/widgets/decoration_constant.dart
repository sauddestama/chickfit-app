import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

const kDecorationCircular10 = BoxDecoration(
  color: AssetColors.gray,
  borderRadius: BorderRadius.all(Radius.circular(10)),
  boxShadow: [
    BoxShadow(
        color: Color(0xFFD0D0D0),
        blurRadius: 2.0,
        offset: Offset(1, 5),
        spreadRadius: 1),
  ],
);

const kDecorationCircular5 = BoxDecoration(
  color: AssetColors.grayCard,
  borderRadius: BorderRadius.all(Radius.circular(5)),
  boxShadow: [
    BoxShadow(
        color: Color(0xFFD0D0D0),
        blurRadius: 2.0,
        offset: Offset(1, 5),
        spreadRadius: 1),
  ],
);

/**
 * Same with kFormInputDecoration
 * if you change kFormInputDecoration dont forget to change this class
 */
/// Custom style for forms widget of this application
class MyFormInputDecoration extends BoxDecoration {
  MyFormInputDecoration(
      {Color? color, bool showShadow = true, bool showBorderError = false})
      : super(
          color: color ?? AssetColors.gray,
          border: showBorderError ? Border.all(color: Colors.red) : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: !showShadow
              ? null
              : [
                  const BoxShadow(
                      color: Color(0xFFD0D0D0),
                      blurRadius: 2.0,
                      offset: Offset(1, 5),
                      spreadRadius: 1),
                ],
        );
}
