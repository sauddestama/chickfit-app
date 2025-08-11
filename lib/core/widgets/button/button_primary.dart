import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/widgets/button/button_base.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String accessibilityLabel;
  final ButtonSize buttonSize;
  final ButtonContent buttonContent;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? disableBackgroundColor;
  final Color? shadowColor;
  final bool enabled;
  final double? width;
  final double? height;
  final bool isLoading;
  final TextStyle? textStyle;

  final BorderRadius? borderRadius;

  final Widget? prefix;
  final Widget? suffix;

  final EdgeInsetsGeometry? padding;

  const ButtonPrimary({
    super.key,
    required this.text,
    required this.onPressed,
    this.accessibilityLabel = '',
    this.buttonSize = ButtonSize.medium,
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.shadowColor,
    this.enabled = true,
    this.width,
    this.height,
    this.isLoading = false,
    this.textStyle,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.padding,
  });

  const ButtonPrimary.small({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.shadowColor,
    this.enabled = true,
    this.width,
    this.height,
    this.isLoading = false,
    this.textStyle,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.padding,
  }) : buttonSize = ButtonSize.small;

  const ButtonPrimary.medium({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.shadowColor,
    this.enabled = true,
    this.width,
    this.height,
    this.isLoading = false,
    this.textStyle,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.padding,
  }) : buttonSize = ButtonSize.medium;

  const ButtonPrimary.large({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.shadowColor,
    this.enabled = true,
    this.width,
    this.height,
    this.isLoading = false,
    this.textStyle,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.padding,
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
      backgroundColor: backgroundColor ?? AssetColors.primaryMain,
      foregroundColor: foregroundColor ?? AssetColors.white,
      borderColor: borderColor ?? backgroundColor,
      disableBackgroundColor: disableBackgroundColor,
      accessibilityLabel: accessibilityLabel,
      isLoading: isLoading,
      textStyle: textStyle,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
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
