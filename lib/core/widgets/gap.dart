import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  final double width;
  final double height;

  const Gap({super.key, this.width = 0, this.height = 0});

  factory Gap.height([double height = 10]) => Gap(height: height, width: 0);

  factory Gap.width([double width = 10]) => Gap(height: 0, width: width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
