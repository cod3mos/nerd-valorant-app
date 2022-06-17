import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';

final titleStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Viga',
  fontSize: ScreenSize.adaptiveFontSize(6.5),
);

final textStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
  fontSize: ScreenSize.adaptiveFontSize(3.5),
);

final subtitleStyle = TextStyle(
  color: greenColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
  fontSize: ScreenSize.adaptiveFontSize(4.5),
);

final subtitleBoldStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
  fontSize: ScreenSize.adaptiveFontSize(4.5),
);

final skipButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.transparent,
  onPrimary: Colors.transparent,
  onSurface: Colors.transparent,
  alignment: Alignment.centerLeft,
  shadowColor: Colors.transparent,
  padding: const EdgeInsets.all(20),
  splashFactory: NoSplash.splashFactory,
);

final nextButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.transparent,
  onPrimary: Colors.transparent,
  onSurface: Colors.transparent,
  alignment: Alignment.centerRight,
  shadowColor: Colors.transparent,
  padding: const EdgeInsets.all(20),
  splashFactory: NoSplash.splashFactory,
);
