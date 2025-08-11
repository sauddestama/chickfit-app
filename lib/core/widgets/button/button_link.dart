import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/widgets/button/button_base.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/core/widgets/text_label.dart';
import 'package:flutter/material.dart';

class ButtonLink extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String accessibilityLabel;
  final ButtonSize buttonSize;
  final Color? surfaceTintColor;
  final TextStyle? textStyle;

  final Widget? prefix;
  final Widget? suffix;

  const ButtonLink.small({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.surfaceTintColor,
    this.textStyle,
    this.prefix,
    this.suffix,
  }) : buttonSize = ButtonSize.small;

  const ButtonLink.medium({
    super.key,
    required this.onPressed,
    required this.text,
    this.accessibilityLabel = '',
    this.surfaceTintColor,
    this.textStyle,
    this.prefix,
    this.suffix,
  }) : buttonSize = ButtonSize.medium;

  @override
  Widget build(BuildContext context) {
    return InkPressableBase(
      onTap: onPressed,
      color: surfaceTintColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefix != null) prefix!,
          if (prefix != null) Gap.width(8),
          TextLabel(
            label: text,
            style: textStyle ??
                buttonSize.textStyle.copyWith(
                  color: AssetColors.primaryMain,
                ),
          ),
          if (suffix != null) Gap.width(8),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
