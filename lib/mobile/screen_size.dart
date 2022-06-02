import 'package:flutter/material.dart';

class ScreenSize {
  static late MediaQueryData _mediaQueryData;

  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData.size.width.floorToDouble();
    screenHeight = _mediaQueryData.size.height.floorToDouble();
  }

  static double adaptiveFontSize(size) {
    return ((_mediaQueryData.size.width / 100) * size).ceilToDouble();
  }
}
