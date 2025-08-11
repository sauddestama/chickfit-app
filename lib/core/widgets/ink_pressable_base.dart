import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

class InkPressableBase extends StatelessWidget {
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget child;
  final String? accessibilityLabel;
  final double? rippleRadius;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final DecorationImage? imageBackground;
  final double? width;

  const InkPressableBase({
    super.key,
    this.onTap,
    this.accessibilityLabel,
    this.padding,
    this.borderRadius,
    this.rippleRadius,
    required this.child,
    this.color,
    this.boxShadow,
    this.border,
    this.imageBackground,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: boxShadow,
      ),
      child: Material(
        color: AssetColors.transparent,
        clipBehavior: Clip.hardEdge,
        child: Semantics(
          excludeSemantics: true,
          label: 'pressable-$accessibilityLabel',
          child: InkWell(
            onTap: onTap,
            radius: rippleRadius,
            borderRadius: borderRadius,
            child: Ink(
              padding: padding,
              width: width,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: color,
                border: border,
                image: imageBackground,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
