import 'package:chickfit/core/resources/resources.dart';
import 'package:flutter/material.dart';

class MyDropdownFormField<T> extends StatelessWidget {
  final String? label;

  final String hint;

  final IconData? leadingIcon;

  final bool obscureText;

  final TextInputType textInputType;
  final String? initialValue;
  final String? Function(T? value)? validator;
  final TextEditingController? controller;
  final FormFieldSetter<T?>? onSaved;
  final ValueChanged<T?>? onChanged;
  final Widget? decorationSuffixIcon;
  final bool? enable;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  const MyDropdownFormField({
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
    this.decorationSuffixIcon,
    required this.items,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      isDense: true,
      onSaved: onSaved,
      value: value,
      onChanged: onChanged,
      style: TextStyle(
        color: kPrimarySwacth.shade900,
        fontFamily: 'OpenSans',
      ),
      decoration: InputDecoration(
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent)),
        label: label != null ? Text(label!) : null,
        prefixIcon: leadingIcon != null
            ? Icon(
                leadingIcon,
                color: Theme.of(context).primaryColor,
              )
            : null,
        contentPadding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
        suffixIcon: decorationSuffixIcon,
        filled: true,
        hintText: hint,
      ),
      validator: validator,
      items: items,
    );
  }
}
