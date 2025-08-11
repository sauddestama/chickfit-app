import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

/// List item with bottom border
class CustomItemDrawer extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? suffix;
  final VoidCallback? onTap;
  final String? subtitle;
  final Color? color;
  final bool noBorder;
  final bool isEnable;

  /// Class constructor
  /// * [title] primary text
  /// * [subtitle] secondary text. Will be put in the right of title
  /// * [suffix] this widget will be put in the right
  /// * [icon] this widget will be put in the left
  /// * [onTap] action if the widget is clicked
  /// * [color] widget color
  const CustomItemDrawer({
    required this.title,
    required this.icon,
    this.suffix,
    this.onTap,
    this.subtitle,
    this.color,
    this.noBorder = false,
    Key? key,
    required this.isEnable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: color ?? Colors.white,
        child: InkWell(
          onTap: isEnable ? onTap : null,
          child: Row(
            children: [
              Flexible(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 5),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: noBorder
                        ? null
                        : Border(
                            bottom: BorderSide(
                            color: Colors.black12,
                          )),
                  ),
                  child: Row(
                    children: [
                      suffix ?? Container(),
                      Spacer(),
                      Text(title),
                      Text(
                        subtitle != null ? ' $subtitle' : '',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        icon!,
                        color: AssetColors.colorPrimaryDark,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
