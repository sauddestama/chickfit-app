import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackIconWidget extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const BackIconWidget({
    Key? key,
    this.size = 32.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkPressableBase(
      onTap: onTap,
      child: SvgPicture.asset(
        "assets/icons/back_button.svg",
        width: size,
        height: size,
      ),
    );
  }
}
