import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';

class IconItem extends StatelessWidget {
  const IconItem({Key? key, required this.icon, required this.size})
      : super(key: key);

  final IconData icon;
  final int size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white.withOpacity(.7),
      size: ScreenSize.height(size),
    );
  }
}
