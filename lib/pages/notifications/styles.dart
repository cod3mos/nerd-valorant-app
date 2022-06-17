import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';

final titleStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
  fontSize: ScreenSize.adaptiveFontSize(6),
);

final textStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Roboto',
  fontSize: ScreenSize.adaptiveFontSize(4),
);

final textBoldStyle = TextStyle(
  color: greenColor,
  fontFamily: 'Roboto',
  fontSize: ScreenSize.adaptiveFontSize(4),
);

final notifyTitleStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Roboto',
  fontSize: ScreenSize.adaptiveFontSize(4),
);

final notifyTitleOvershadowedStyle = TextStyle(
  color: const Color.fromARGB(90, 255, 255, 255),
  fontFamily: 'Roboto',
  fontSize: ScreenSize.adaptiveFontSize(4),
);

final notifyTextStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Roboto',
  fontSize: ScreenSize.adaptiveFontSize(3.5),
);

final notifyTextOvershadowedStyle = TextStyle(
  color: const Color.fromARGB(90, 255, 255, 255),
  fontFamily: 'Roboto',
  fontSize: ScreenSize.adaptiveFontSize(3.5),
);
