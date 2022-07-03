import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';

final bannerTitleStyle = TextStyle(
  color: greenColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
  fontSize: ScreenSize.adaptiveFontSize(7),
);

final bannerTextStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Viga',
  fontSize: ScreenSize.adaptiveFontSize(3),
);

final halftoneTitleStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Viga',
  fontWeight: FontWeight.w500,
  fontSize: ScreenSize.adaptiveFontSize(6),
);

final halftoneTextStyle = TextStyle(
  color: greenColor,
  fontFamily: 'Viga',
  fontSize: ScreenSize.adaptiveFontSize(3),
);

final halftoneCodeTextStyle = TextStyle(
  color: whiteColor,
  fontFamily: 'Roboto',
  fontSize: ScreenSize.adaptiveFontSize(3),
);
