import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';

class LoadingItem extends StatelessWidget {
  const LoadingItem({Key? key, required this.text}) : super(key: key);

  final Text text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(greenColor),
        ),
        SizedBox(
          height: ScreenSize.height(5),
        ),
        text,
      ],
    );
  }
}
