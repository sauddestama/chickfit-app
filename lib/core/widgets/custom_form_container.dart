import 'package:chickfit/core/resources/constant_styles.dart';
import 'package:flutter/material.dart';

class CustomFormContainer extends StatelessWidget {
  final bool hasError;
  final String? errorText;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final String? label;
  const CustomFormContainer(
      {Key? key,
      this.hasError = false,
      this.errorText,
      required this.child,
      this.padding,
      this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: kTextFieldLabelStyle,
          ),
        if (label != null)
          const SizedBox(
            height: 2,
          ),
        Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xffF1F3FD),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffBDC3D6), width: 1.0),
          ),
          child: child,
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText ?? '',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          )
      ],
    );
  }
}
