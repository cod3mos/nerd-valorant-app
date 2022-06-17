import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/profile/styles.dart';
import 'package:nerdvalorant/themes/global_styles.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton(
      {Key? key, required this.icon, required this.text, required this.onTouch})
      : super(key: key);

  final IconData icon;
  final String text;
  final Function onTouch;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        onPrimary: greenColor,
      ),
      onPressed: () => onTouch(),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Icon(
              icon,
              color: whiteColor,
              semanticLabel: icon.toString(),
              size: ScreenSize.adaptiveFontSize(7.5),
            ),
          ),
          Expanded(
            flex: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                text,
                style: textStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              Ionicons.chevron_forward_outline,
              color: whiteColor,
              semanticLabel: icon.toString(),
              size: ScreenSize.adaptiveFontSize(7),
            ),
          ),
        ],
      ),
    );
  }
}
