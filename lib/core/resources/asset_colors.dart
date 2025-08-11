import 'package:flutter/material.dart';

class AssetColors {
  AssetColors._();
  static const transparent = Colors.transparent;

  static const Color backgroundColor = Color(0xffF2F2F2);
  static const Color colorPrimary = Color(0xff41B883);
  static const Color colorPrimaryShades = Color(0xff7ACDA8);
  static const Color colorPrimary2 = Color(0xff00AC8D);
  static const Color colorPrimaryDark = Color(0xff008756);
  static const Color colorSecondary = Color(0xffffa726);
  static const Color colorAccent = Color(0xff00B1F5);
  static const Color chambrayBlue = Color(0xff385595);
  static const Color fillTextFieldColor = Color(0xff33b488);
  static const Color grey = Color(0xFF395667);
  static const Color disabledTextInput = Color.fromRGBO(242, 242, 242, 1);
  static const Color enabledTextInput = Color.fromRGBO(255, 255, 255, 1);
  static const Color disableFillTextInput = Color(0xFFF3F3F3);
  static const Color disabledInputTextColor = Color(0xffCDCDCD);
  static const Color disabledStrokeTextInput = Color(0xffF2F2F2);
  static const Color enabledInputTextColor = Color.fromRGBO(22, 58, 80, 1);
  static const Color greyTextColor = Color.fromRGBO(57, 86, 103, 1);
  static const Color unselectedChipColor = Color(0xffD9D9D9);

  static const Gradient primaryGradient = LinearGradient(colors: [
    Color(0xFF008756),
    Color(0xFF41B883),
  ], stops: [
    0.1,
    1
  ]);
  static const Gradient errorGradient = LinearGradient(colors: [
    Color(0xFFFE6D6D),
    Color(0xFFE25252),
  ]);

  static const Color gray = Color(0xfff5f6f8);
  static const Color grayCard = Color(0xffF2F2F2);
  static const Color colorGreen = Color(0xff008756);
  static const Color colorGreenCalm = Color(0xff199a69);

  static const Color colorYellow = Color(0xa6ffd453);
  static const Color colorOrange = Color(0xffd43d17);
  static const Color redBlossom = Color(0xffAC1414);

  static const Color backgroundGrey = Color(0xffF5F5F5);
  static const Color blackText = Color(0xff1e1e1e);
  static const Color blackBackground = Color(0xff202020);
  static const Color goldColor = Color(0xffECBC40);
  static const Color greyCard2 = Color(0xffEBEBEB);
  static const Color greyCard3 = Color(0xffE0E0E0);

  /// NEUTRAL COLORS
  static const neutral10 = Color(0xffffffff);
  static const neutral20 = Color(0xffF8F8F9);
  static const neutral30 = Color(0xffEDEDED);
  static const neutral40 = Color(0xffE0E0E0);
  static const neutral50 = Color(0xffC2C2C2);
  static const neutral60 = Color(0xff9E9E9E);
  static const neutral70 = Color(0xff757575);
  static const neutral80 = Color(0xff616161);
  static const neutral90 = Color(0xff404040);
  static const neutral100 = Color(0xff0A0A0A);

  /// PRIMARY COLORS (Green Theme - based on #0BAB7D)
  static const primary03 = Color(0xFFE7F9F4); // Lightest tint
  static const primary05 = Color(0xFFD6F4EC);
  static const primary10 = Color(0xFFB8EADC);
  static const primary20 = Color(0xFF8CDBC5);
  static const primary30 = Color(0xFF5DCCAD);
  static const primary40 = Color(0xFF34BD96);
  static const primary45 = Color(0xFF1DB388);
  static const primary50 = Color(0xFF0BAB7D); // Base green
  static const primary60 = Color(0xFF09986F);
  static const primary70 = Color(0xFF087B5C);
  static const primary80 = Color(0xFF066147);
  static const primary90 = Color(0xFF044D39);
  static const primary100 = Color(0xFF023426); // Darkest shade

  /// SECONDARY COLORS
  static const secondary05 = Color(0xffFFF7ED);
  static const secondary10 = Color(0xffFEEDD6);
  static const secondary20 = Color(0xffFEEDD6);
  static const secondary30 = Color(0xffFABB77);
  static const secondary40 = Color(0xffF79440);
  static const secondary50 = Color(0xffF47920);
  static const secondary60 = Color(0xffE55C11);
  static const secondary65 = Color(0xffFB5D04);
  static const secondary70 = Color(0xffBE4510);
  static const secondary80 = Color(0xff973715);
  static const secondary90 = Color(0xff7A2F14);
  static const secondary100 = Color(0xff421608);

  /// SUCCESS COLORS
  static const success05 = Color(0xffF1FCF5);
  static const success10 = Color(0xffDEFAEA);
  static const success20 = Color(0xffBEF4D4);
  static const success30 = Color(0xff8BEAB2);
  static const success40 = Color(0xff52D689);
  static const success50 = Color(0xff27AE60);
  static const success60 = Color(0xff1D9C53);
  static const success70 = Color(0xff1A7B43);
  static const success80 = Color(0xff1A6139);
  static const success90 = Color(0xff175031);
  static const success100 = Color(0xff072C18);

  /// WARNING COLORS
  static const warning05 = Color(0xffFFFEE7);
  static const warning10 = Color(0xffFFFDC1);
  static const warning20 = Color(0xffFFF686);
  static const warning30 = Color(0xffFFE941);
  static const warning40 = Color(0xffFFD80D);
  static const warning50 = Color(0xffFFC800);
  static const warning60 = Color(0xffD19200);
  static const warning65 = Color(0xffFFB210);
  static const warning70 = Color(0xffA66802);
  static const warning80 = Color(0xff89510A);
  static const warning90 = Color(0xff74420F);
  static const warning100 = Color(0xff442204);

  /// DANGER COLORS
  static const danger05 = Color(0xffFEF2F2);
  static const danger10 = Color(0xffFDE3E3);
  static const danger20 = Color(0xffFCCCCC);
  static const danger30 = Color(0xffF9A8A8);
  static const danger40 = Color(0xffF37676);
  static const danger50 = Color(0xffE84040);
  static const danger60 = Color(0xffD62C2C);
  static const danger70 = Color(0xffB42121);
  static const danger80 = Color(0xff951F1F);
  static const danger90 = Color(0xff7C2020);
  static const danger100 = Color(0xff430C0C);

  /// PRIMARY TOKEN COLORS
  static const primaryMain = primary50;
  static const primarySurface = primary05;
  static const primaryBorder = primary40;
  static const primaryHover = primary60;
  static const primaryPressed = primary90;
  static const primaryFocus = primary50;

  /// SECONDARY TOKEN COLORS
  static const secondaryMain = secondary50;
  static const secondarySurface = secondary05;
  static const secondaryBorder = secondary40;
  static const secondaryHover = secondary60;
  static const secondaryPressed = secondary90;
  static const secondaryFocus = secondary50;

  /// DANGER TOKEN COLORS
  static const dangerMain = danger50;
  static const dangerSurface = danger05;
  static const dangerBorder = danger40;
  static const dangerHover = danger60;
  static const dangerPressed = danger90;
  static const dangerFocus = danger50;

  /// WARNING TOKEN COLORS
  static const warningMain = warning50;
  static const warningSurface = warning05;
  static const warningBorder = warning40;
  static const warningHover = warning60;
  static const warningPressed = warning90;
  static const warningFocus = warning50;

  /// SUCCESS TOKEN COLORS
  static const successMain = success50;
  static const successSurface = success05;
  static const successBorder = success40;
  static const successHover = success60;
  static const successPressed = success90;
  static const successFocus = success50;

  /// NEUTRAL TOKEN COLORS
  static const neutralSurfaceWhite = neutral10;
  static const neutralSurfaceDark = neutral100;
  static const neutralBorder = neutral40;
  static const surface = neutral20;
  static const surfaceDisable = neutral30;
  static const surfaceDark = neutral100;
  static const borderDefault = neutral40;
  static const borderDisable = neutral50;
  static const hover = neutral60;
  static const pressed = neutral70;

  /// TEXT & ICON COLORS
  static const textTitle = neutral100;
  static const textBody = neutral80;
  static const textPrimary = primary50;
  static const textSecondary = Color(0xff6C6C6C);
  static const textPlaceholder = neutral60;
  static const textDisable = neutral50;
  static const textBlack = neutral100;
  static const textWhite = neutral10;
  static const textError = danger50;
  static const textSubtitle = neutral90;
  static const textLight = neutral20;

  /// EXTRA COLORS
  static const extraOrangeMain = Color(0xffFB5D04);
  static const extraOrangeSurface = Color(0xffFFF7ED);
  static const extraBlueMain = Color(0xffFB5D04);
  static const extraBlueSurface = Color(0xffF2FCFF);
  static const extraYellowMain = Color(0xffFFB210);
  static const extraYellowSurface = Color(0xffFFFEE7);
  static const extraPurpleMain = Color(0xff8620FF);
  static const extraPurpleSurface = Color(0xffF5EDFF);

  static const disableMain = neutral30;
  static const disableSurface = neutral20;
  static const disableBorder = neutral40;
  static const disableHover = neutral50;
  static const disablePressed = neutral70;

  static const black = Color(0xff000000);
  static const white = neutral10;
  static const inputLabelColor = Color(0xff969696);
  static const background = neutral10;
  static const border = primaryBorder;
  static const dark = neutral90;

  static Color primaryShadowColor =
      const Color(0xffA6AFC3).withValues(alpha: 0.4);
  static Color shadowColor = const Color(0xFF292929);
  static Color bottomNavigationShadowColor =
      const Color(0xff0D0A2C).withValues(alpha: 0.06);
  static const disableNeutral = neutral50;
  static const Color otpShadow = Color(0xffc6c6c6);
  static const Gradient gradientPrimaryMain = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AssetColors.primary60,
      AssetColors.secondaryMain,
    ],
    stops: [0.4255, 0.9892],
  );

  //// GRADIENT COLORS
  static const Gradient gradientPrimary = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.topLeft,
    colors: [
      AssetColors.primary60,
      Color(0XFF193A7D),
    ],
  );

  static const Gradient gradientPrimary68 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AssetColors.primary60,
      AssetColors.primary80,
    ],
  );

  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey900 = Color(0xFF212121);
}

const MaterialColor kPrimarySwacth = MaterialColor(
  0xff202020,
  // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
  <int, Color>{
    50: Color(0xffe9e9e9), //10%
    100: Color(0xffd2d2d2), //20%
    200: Color(0xffa6a6a6), //30%
    300: Color(0xff797979), //40%
    400: Color(0xff4d4d4d), //60%
    500: Color(0xff363636), //60%
    600: Color(0xff202020), //70%
    700: Color(0xff202020), //80%
    800: Color(0xff161616), //90%
    900: Color(0xff000000), //100%
  },
);
