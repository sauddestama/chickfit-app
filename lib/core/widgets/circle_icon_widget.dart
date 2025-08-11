import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

class CircleIconWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? title;
  final Color? backgroudColor;
  final double? size;
  const CircleIconWidget(
      {Key? key,
      required this.icon,
      this.onTap,
      this.title,
      this.backgroudColor,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onTap == null)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: backgroudColor ?? kPrimarySwacth.shade600,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: size,
              ),
            ),
          ),
        if (onTap != null)
          InkWell(
              onTap: onTap,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  width: size ?? 60,
                  height: size ?? 60,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: backgroudColor ?? kPrimarySwacth.shade600,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              )),
        if (title != null) const SizedBox(height: 5),
        if (title != null)
          Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
      ],
    );
  }
}
