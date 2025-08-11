import 'package:chickfit/core/resources/theme/theme_fonts.dart';
import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String label;
  final String accessibilityLabel;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextStyle? fontFamily;

  const TextLabel({
    super.key,
    this.label = '',
    this.accessibilityLabel = '',
    this.style,
    this.maxLines,
    this.textAlign,
    this.color,
    this.overflow,
    this.softWrap,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      label: 'text-$accessibilityLabel',
      child: Text(
        label,
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: softWrap,
        overflow: overflow,
        style: ThemeFonts.defaultLabel
            .merge(TextStyle(color: color))
            .merge(style)
            .merge(fontFamily ?? ThemeFonts.roboto)
            .merge(TextStyle(height: 1.5)),
      ),
    );
  }
}
