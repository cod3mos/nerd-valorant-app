import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';

// ------------------------------------------------------------------------------------------------------------------------------------------
// Adaptive Size: 2 => 8px | 2.5 => 10px | 3.5 => 14px | 4 => 16px  | 5 => 20px | 6 => 24px | 7 => 28px | 8 => 32px | 9 => 36px | 10 => 40px
// ------------------------------------------------------------------------------------------------------------------------------------------

Color whiteColor = const Color.fromRGBO(242, 244, 246, 1);
Color blackColor = const Color.fromRGBO(22, 23, 27, 1);
Color greenColor = const Color.fromRGBO(25, 195, 98, 1);

final textStyle = TextStyle(
  color: blackColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.normal,
  fontSize: ScreenSize.adaptiveFontSize(4),
);
