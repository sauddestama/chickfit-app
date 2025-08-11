import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/widgets/button/button_base.dart';
import 'package:flutter/material.dart';

class ButtonSecondary extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String accessibilityLabel;
  final ButtonSize buttonSize;
  final ButtonContent buttonContent;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? disableBackgroundColor;
  final bool enabled;
  final double? width;
  final double? height;
  final bool isLoading;
  final TextStyle? textStyle;

  final BorderRadius? borderRadius;
  final double? elevation;

  final Widget? prefix;
  final Widget? suffix;

  final EdgeInsetsGeometry? padding;
  final Color? shadowColor;

  const ButtonSecondary({
    super.key,
    required this.onPressed,
    required this.text,
    this.buttonSize = ButtonSize.medium,
    this.accessibilityLabel = '',
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.enabled = true,
    this.width,
    this.height,
    this.isLoading = false,
    this.textStyle,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.elevation,
    this.padding,
    this.shadowColor,
  });

  const ButtonSecondary.small({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.enabled = true,
    this.width,
    this.height,
    this.isLoading = false,
    this.textStyle,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.elevation,
    this.padding,
    this.shadowColor,
  }) : buttonSize = ButtonSize.small;

  const ButtonSecondary.medium({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.enabled = true,
    this.width,
    this.height,
    this.isLoading = false,
    this.textStyle,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.elevation,
    this.padding,
    this.shadowColor,
  }) : buttonSize = ButtonSize.medium;

  const ButtonSecondary.large({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.enabled = true,
    this.width,
    this.height,
    this.isLoading = false,
    this.textStyle,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.elevation,
    this.padding,
    this.shadowColor,
  }) : buttonSize = ButtonSize.large;

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      padding: padding,
      buttonContent: buttonContent,
      buttonSize: buttonSize,
      width: width,
      height: height,
      onPressed: onPressed,
      text: text,
      enabled: enabled,
      backgroundColor: backgroundColor ?? AssetColors.neutral10,
      foregroundColor: foregroundColor ?? AssetColors.primaryMain,
      borderColor: enabled
          ? borderColor ?? AssetColors.primaryMain
          : AssetColors.borderDisable,
      disableBackgroundColor: disableBackgroundColor,
      accessibilityLabel: accessibilityLabel,
      isLoading: isLoading,
      textStyle: textStyle,
      borderRadius: borderRadius,
      elevation: elevation,
      prefix: Padding(
        padding: ThemePadding.pr8,
        child: prefix,
      ),
      suffix: Padding(
        padding: ThemePadding.pl8,
        child: suffix,
      ),
      shadowColor: shadowColor,
    );
  }
}
