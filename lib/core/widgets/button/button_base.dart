import 'package:chickfit/core/constant/asset_animated.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/asset_sizes.dart';
import 'package:chickfit/core/resources/theme/theme_border.dart';
import 'package:chickfit/core/resources/theme/theme_fonts.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/widgets/text_label.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum ButtonSize { small, medium, large }

enum ButtonContent { start, center }

extension ButtonSizeExtension on ButtonSize {
  double get width {
    switch (this) {
      case ButtonSize.small:
        return 129.ds;
      case ButtonSize.medium:
        return 154.ds;
      case ButtonSize.large:
        return 172.ds;
    }
  }

  double get height {
    switch (this) {
      case ButtonSize.small:
        return 32.ds;
      case ButtonSize.medium:
        return 44.ds;
      case ButtonSize.large:
        return 48.ds;
    }
  }

  TextStyle get textStyle {
    switch (this) {
      case ButtonSize.small:
        return ThemeFonts.bodyXsBold;
      case ButtonSize.medium:
        return ThemeFonts.bodySmBold;
      case ButtonSize.large:
        return ThemeFonts.bodyMdBold;
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case ButtonSize.small:
        return ThemePadding.ph12;
      case ButtonSize.medium:
        return ThemePadding.ph16;
      case ButtonSize.large:
        return ThemePadding.ph16;
    }
  }
}

class ButtonBase extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? prefix;
  final Widget? suffix;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool isDisable;
  final String accessibilityLabel;
  final TextStyle? textStyle;
  final bool enabled;
  final double? width;
  final double? height;
  final ButtonSize buttonSize;
  final ButtonContent buttonContent;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? disableBackgroundColor;
  final Color? shadowColor;
  final bool isLoading;
  final double? elevation;

  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const ButtonBase({
    super.key,
    required this.onPressed,
    required this.text,
    this.prefix,
    this.suffix,
    this.style,
    this.focusNode,
    this.isDisable = false,
    this.accessibilityLabel = '',
    this.textStyle,
    this.enabled = true,
    this.width,
    this.height,
    this.buttonSize = ButtonSize.medium,
    this.buttonContent = ButtonContent.center,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disableBackgroundColor,
    this.shadowColor,
    this.elevation,
    this.isLoading = false,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? buttonSize.height,
      child: Semantics(
        excludeSemantics: true,
        label: 'button-$accessibilityLabel',
        child: ElevatedButton(
          onPressed: (enabled && !isLoading)
              ? () {
                  onPressed();
                }
              : null,
          focusNode: focusNode,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding ?? buttonSize.padding,
            elevation: elevation,
            disabledBackgroundColor: disableBackgroundColor ??
                (isLoading ? backgroundColor : AssetColors.disableMain),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? ThemeBorder.bc8,
              side: BorderSide(
                color: borderColor ?? Colors.transparent,
              ),
            ),
            shadowColor: shadowColor,
          ),
          child: isLoading
              ? Lottie.asset(
                  AssetAnimated.loadingCircular,
                  width: AssetSizes.s24,
                  height: AssetSizes.s24,
                )
              : buttonContent == ButtonContent.center
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (prefix != null) prefix!,
                        Flexible(
                          child: TextLabel(
                            label: text,
                            style: textStyle ?? buttonSize.textStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (suffix != null) suffix!,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (prefix != null) prefix!,
                        TextLabel(
                          label: text,
                          style: textStyle ?? buttonSize.textStyle,
                        ),
                        if (suffix != null) suffix!,
                      ],
                    ),
        ),
      ),
    );
  }
}
