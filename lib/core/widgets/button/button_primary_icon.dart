import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/widgets/button/button_base.dart';
import 'package:flutter/material.dart';

import '../gap.dart';

class ButtonPrimaryIcon extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final Function() onPressed;
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
  final double gap;

  final double? elevation;

  const ButtonPrimaryIcon({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.buttonSize = ButtonSize.medium,
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.enabled = true,
    this.width,
    this.height,
    this.prefix,
    this.suffix,
    this.isLoading = false,
    this.textStyle,
    this.gap = 8,
    this.elevation,
  });

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
      backgroundColor: backgroundColor ?? AssetColors.dark,
      foregroundColor: foregroundColor ?? AssetColors.white,
      borderColor: borderColor ?? backgroundColor,
      disableBackgroundColor: disableBackgroundColor,
      accessibilityLabel: 'primary-$accessibilityLabel',
      textStyle: textStyle,
      elevation: elevation,
      prefix: prefix != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [prefix!, Gap.width(gap)],
            )
          : null,
      suffix: suffix != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [Gap.width(gap), suffix!],
            )
          : null,
      isLoading: isLoading,
    );
  }
}
