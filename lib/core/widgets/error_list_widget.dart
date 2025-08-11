import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/utils/utils.dart';
import 'package:chickfit/core/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorListWidget extends StatelessWidget {
  final String? text;

  final bool pullToRefresh;
  final VoidCallback? onRetry;
  final double? paddingTop;
  final double? animWidth;
  final double? animHeigth;
  final String? assetName;

  const ErrorListWidget(
      {Key? key,
      this.text,
      required this.pullToRefresh,
      this.onRetry,
      this.paddingTop,
      this.animWidth,
      this.animHeigth,
      this.assetName})
      : assert(pullToRefresh && onRetry != null || !pullToRefresh),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: paddingTop ?? SizeConfig.heightMultiplier * 15),
            child: Lottie.asset('assets/anim/empty2.json',
                height: animHeigth ?? 200,
                width: animWidth,
                fit: BoxFit.fitHeight,
                alignment: Alignment.center),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Center(
          child: Text(
            text ?? 'Gagal mengambil data',
            style: const TextStyle(fontSize: 16, color: AssetColors.blackText),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        if (!pullToRefresh)
          RoundedButton(
            text: "Muat Ulang",
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            onTap: onRetry,
            roundValue: 8,
            textColor: Colors.white,
            backgroundColor: AssetColors.colorPrimaryDark,
          ),
        if (pullToRefresh)
          const Center(
            child: Text(
              "Pull to refresh",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300),
            ),
          ),
      ],
    );
  }
}
