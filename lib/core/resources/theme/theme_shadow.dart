import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

class ThemeShadow {
  const ThemeShadow._();

  static BoxShadow smallShadow = BoxShadow(
    color: AssetColors.primaryShadowColor,
    spreadRadius: 0,
    blurRadius: 3,
    offset: const Offset(0, 1),
    blurStyle: BlurStyle.inner,
  );

  static BoxShadow mediumShadow = BoxShadow(
    color: AssetColors.shadowColor.withValues(alpha: 0.1),
    spreadRadius: 0,
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  static BoxShadow largeShadow = BoxShadow(
    color: AssetColors.black.withValues(alpha: 0.1),
    spreadRadius: 0,
    blurRadius: 12,
    offset: const Offset(0, 5),
    blurStyle: BlurStyle.inner,
  );

  static BoxShadow bottomNavigationShadow = BoxShadow(
    color: AssetColors.shadowColor.withValues(alpha: 0.08),
    blurRadius: 20,
    offset: const Offset(0, -4),
  );

  static BoxShadow cardShadow = BoxShadow(
    color: AssetColors.shadowColor.withValues(alpha: 0.12),
    blurRadius: 20,
    offset: Offset(0, 4),
  );
}
