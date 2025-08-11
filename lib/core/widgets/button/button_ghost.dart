import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/widgets/button/button_base.dart';
import 'package:flutter/material.dart';

class ButtonGhost extends StatelessWidget {
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

  final Widget? prefix;
  final Widget? suffix;

  const ButtonGhost.small({
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
  }) : buttonSize = ButtonSize.small;

  const ButtonGhost.medium({
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
  }) : buttonSize = ButtonSize.medium;

  const ButtonGhost.large({
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
  }) : buttonSize = ButtonSize.large;

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      buttonContent: buttonContent,
      buttonSize: buttonSize,
      width: width,
      height: height,
      onPressed: onPressed,
      text: text,
      enabled: enabled,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? AssetColors.primaryMain,
      borderColor: borderColor ?? Colors.transparent,
      disableBackgroundColor: disableBackgroundColor,
      accessibilityLabel: accessibilityLabel,
      isLoading: isLoading,
      textStyle: textStyle,
      borderRadius: borderRadius,
      prefix: Padding(
        padding: ThemePadding.pr8,
        child: prefix,
      ),
      suffix: Padding(
        padding: ThemePadding.pl8,
        child: suffix,
      ),
      elevation: 0,
    );
  }
}
