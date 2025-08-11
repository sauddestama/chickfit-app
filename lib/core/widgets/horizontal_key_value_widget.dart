import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalLabelValueWidget extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;

  final bool loading;

  const HorizontalLabelValueWidget._(
      {Key? key,
      required this.label,
      this.value,
      this.valueWidget,
      required this.loading})
      : super(key: key);

  factory HorizontalLabelValueWidget(
      {Key? key,
      required String label,
      required String? value,
      bool? loading}) {
    return HorizontalLabelValueWidget._(
      label: label,
      value: value,
      loading: loading ?? false,
    );
  }

  factory HorizontalLabelValueWidget.valueWidget(
      {Key? key,
      required String label,
      required Widget valueWidget,
      bool? loading}) {
    return HorizontalLabelValueWidget._(
      label: label,
      valueWidget: valueWidget,
      loading: loading ?? false,
    );
  }

  factory HorizontalLabelValueWidget.loading(
      {Key? key, required String label}) {
    return HorizontalLabelValueWidget._(
      label: label,
      loading: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 14,
              color: value == null && valueWidget == null && !loading
                  ? Colors.grey
                  : AssetColors.grey,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            )),
        const SizedBox(
          width: 4,
        ),
        if (loading)
          Flexible(
            child: Shimmer.fromColors(
              highlightColor: Colors.white10,
              baseColor: Colors.grey.shade300,
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: AssetColors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$label    ',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AssetColors.grey,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ),
        if (!loading)
          Flexible(
            child: valueWidget ??
                Text(value ?? '-',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: AssetColors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    )),
          ),
      ],
    );
  }
}
