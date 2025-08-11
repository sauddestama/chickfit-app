import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

import 'custom_text_form_field.dart' as custom_tff;

class InputText extends StatelessWidget {
  const InputText(this.label,
      {this.hideLabel = false,
      this.textInputType = TextInputType.text,
      this.isPassword = false,
      this.readOnly = false,
      this.required = false,
      this.loginPage = false,
      this.textController,
      this.onSubmit,
      this.hint,
      this.focusNode,
      this.errorMessage,
      this.validator,
      this.onSaved,
      this.onChanged,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.initialValue,
      Key? key,
      this.labelColor,
      this.leadingIcon,
      this.suffixIcon,
      this.maxLines = 1,
      this.minLines,
      this.textInputAction,
      this.obscure = false,
      this.borderColor = AssetColors.colorPrimaryShades,
      this.errorTextColor})
      : super(key: key);

  const InputText.login(
    this.label, {
    this.hideLabel = false,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.required = false,
    this.loginPage = true,
    this.textController,
    this.onSubmit,
    this.hint,
    this.focusNode,
    this.errorMessage,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.initialValue,
    Key? key,
    this.labelColor,
    this.leadingIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.obscure = false,
    this.borderColor,
    this.textInputAction,
    this.errorTextColor,
  }) : super(key: key);

  final TextInputAction? textInputAction;
  final String label;
  final String? hint;
  final String? initialValue;
  final TextInputType textInputType;
  final bool isPassword, readOnly, loginPage;
  final TextEditingController? textController;
  final FocusNode? focusNode;
  final bool required;
  final bool hideLabel;
  final Function(String)? onSubmit;
  final String? errorMessage;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onSaved;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode autovalidateMode;
  final Color? labelColor;
  final bool obscure;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final int? minLines;
  final int? maxLines;
  final Color? borderColor;
  final Color? errorTextColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!hideLabel && loginPage)
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 7),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: AssetColors.black,
              ),
            ),
          ),
        if (!hideLabel && !loginPage)
          Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: labelColor ?? AssetColors.grey,
                  fontWeight: FontWeight.bold,
                ),
              )),
        custom_tff.TextFormField(
            initialValue: initialValue,
            controller: textController,
            focusNode: focusNode,
            obscureText: obscure,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            readOnly: readOnly,
            minLines: minLines,
            maxLines: maxLines,
            cursorColor: AssetColors.colorPrimary,
            borderColor:
                readOnly ? AssetColors.disabledInputTextColor : borderColor,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'OpenSans',
              color: readOnly
                  ? AssetColors.enabledInputTextColor
                  : AssetColors.enabledInputTextColor,
            ),
            onFieldSubmitted: onSubmit,
            onChanged: onChanged,
            onSaved: onSaved,
            autovalidateMode: autovalidateMode,
            validator: (value) {
              if (required && (value == null || value.isEmpty)) {
                return "${label} harus diisi";
              }

              return validator?.call(value);
            },
            errorMessage: errorMessage,
            errorTextColor: errorTextColor,
            decoration: InputDecoration(
                prefixIcon: leadingIcon,
                suffixIcon: suffixIcon,
                errorStyle: const TextStyle(
                  fontSize: 0,
                  color: Colors.transparent,
                  height: 0.001,
                ),
                errorText: errorMessage,
                hintText: hint ?? label,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: leadingIcon != null ? 0 : 12),
                suffixIconConstraints: const BoxConstraints(
                    maxHeight: 35, maxWidth: 48, minWidth: 40),
                fillColor: readOnly
                    ? AssetColors.disableFillTextInput.withOpacity(0.5)
                    : Colors.white,
                disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true)),
      ],
    );
  }
}
