import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/halftones/styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';

class HalftonesBannerItem extends StatelessWidget {
  const HalftonesBannerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height(15),
      width: ScreenSize.screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bannerBackground),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'RETÍCULAS',
                  style: bannerTitleStyle,
                ),
                const TextSpan(
                  text: '\n\n',
                ),
                TextSpan(
                  text:
                      'ESCOLHA A RETÍCULA QUE MAIS COMBINA COM A SUAS JOGADAS',
                  style: bannerTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
