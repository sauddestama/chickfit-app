import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String? label;

  final String hint;

  final IconData? leadingIcon;

  final bool obscureText;

  final TextInputType textInputType;
  final String? initialValue;

  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final Widget? decorationSuffixIcon;
  final bool? enable;
  final bool enableInteractiveSelection;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;

  const MyTextFormField({
    this.label,
    this.enable = true,
    required this.hint,
    this.leadingIcon,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.validator,
    this.controller,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.maxLines,
    this.minLines,
    this.decorationSuffixIcon,
    this.fillColor,
    this.enableInteractiveSelection = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      enabled: enable,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      enableInteractiveSelection: enableInteractiveSelection,
      focusNode: !enableInteractiveSelection ? AlwaysDisabledFocusNode() : null,
      maxLines: maxLines ?? 1,
      minLines: minLines,
      style: TextStyle(
        color: kPrimarySwacth.shade900,
        fontFamily: 'OpenSans',
      ),
      decoration: InputDecoration(
          fillColor: fillColor ?? Colors.white,
          prefixIcon: leadingIcon != null
              ? Icon(
                  leadingIcon,
                  color: Theme.of(context).primaryColor,
                )
              : null,
          suffixIcon: decorationSuffixIcon,
          filled: true,
          isDense: true,
          hintText: hint,
          floatingLabelStyle: TextStyle(color: AssetColors.black),
          labelStyle: TextStyle(color: AssetColors.black.withOpacity(0.3)),
          hintStyle: TextStyle(color: AssetColors.black.withOpacity(0.3)),
          label: label != null ? Text(label!) : null),
      validator: validator,
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
