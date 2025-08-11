import 'dart:ui';

class SizeConfig {
  static double screenWidth = 0;

  static double screenHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;

  static double heightMultiplier = 0;

  static double widthMultiplier = 0;

  static bool isMobile = false;

  static void init(Size size) {
    screenWidth = size.width;
    screenHeight = size.height;

    if (screenWidth < 450) {
      isMobile = true;
      // print(isMobile);
    }

    textMultiplier = screenHeight / 100;
    imageSizeMultiplier = screenWidth / 100;
    heightMultiplier = screenHeight / 100;
    widthMultiplier = screenWidth / 100;
  }

  static double propotionWidth(double m, double t) {
    return widthMultiplier * (isMobile ? m : t);
  }

  static double propotionHeight(double m, double t) {
    return heightMultiplier * (isMobile ? m : t);
  }
}
