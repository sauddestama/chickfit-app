import 'package:chickfit/core/resources/asset_sizes.dart';
import 'package:flutter/widgets.dart';

class SizeUtil {
  SizeUtil._();

  static double _screenWidth = 0.0;
  static double _screenHeight = 0.0;
  static double _statusBarHeight = 0.0;
  static double _bottomBarHeight = 0.0;
  static bool _isTablet = false;

  static void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _statusBarHeight = MediaQuery.of(context).viewPadding.top;
    _bottomBarHeight = MediaQuery.of(context).viewPadding.bottom;
    _isTablet = MediaQuery.of(context).size.width >= 600;
  }

  // Example upper bound

  // Get current screen width
  static double get getScreenWidth => _screenWidth;

  // Get current screen height
  static double get getScreenHeight => _screenHeight;

  // Get status bar height
  static double get getStatusBarHeight => _statusBarHeight;

  // Get bottom bar height
  static double get getBottomBarHeight => _bottomBarHeight;

  static bool get isTablet => _isTablet;

  static double dynamicSize(double value) {
    double width = getScreenWidth;
    double scale = width / AssetSizes.defaultScreenWidth;
    return value * scale;
  }

  static double responsiveWidth(double value) {
    double width = getScreenWidth;
    return value / 100 * width;
  }
}
