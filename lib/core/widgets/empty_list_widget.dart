import 'package:chickfit/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyListWidget extends StatelessWidget {
  final String text;
  const EmptyListWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(MediaQuery.of(context).size);
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 20),
            child: Lottie.asset(
              'assets/anim/empty_anim.json',
              width: SizeConfig.screenWidth / 2.5,
              height: SizeConfig.screenWidth / 2.5,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 5,
        ),
        Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Color(0xff8C8C8C),
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}
