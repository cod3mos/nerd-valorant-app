import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem({Key? key, required this.icon, required this.color})
      : super(key: key);

  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(icon, color: color),
    );
  }
}
