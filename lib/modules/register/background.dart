import 'package:chickfit/core/resources/resources.dart';
import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  const BackGround({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF55cc95),
                Color(0xFF57c291),
                Color(0xFF33b488),
              ],
              stops: [0.1, 0.5, 0.9],
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 30,
          child: CircleAvatar(
            backgroundColor: AssetColors.colorPrimaryDark.withOpacity(0.5),
            radius: 20,
          ),
        ),
        Positioned(
          top: 24,
          left: 30,
          child: CircleAvatar(
            backgroundColor: AssetColors.colorPrimaryDark.withOpacity(0.3),
            radius: 20,
          ),
        ),
        Positioned(
          top: 40,
          left: 50,
          child: CircleAvatar(
            backgroundColor: AssetColors.colorPrimaryDark.withOpacity(0.5),
            radius: 35,
          ),
        ),
        Positioned(
          bottom: 40,
          right: 42,
          child: CircleAvatar(
            backgroundColor: AssetColors.colorPrimaryDark.withOpacity(0.3),
            radius: 30,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset(
            'assets/leaf.png',
            width: 120,
          ),
        ),
      ],
    );
  }
}
