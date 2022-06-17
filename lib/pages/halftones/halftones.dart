import 'package:flutter/material.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';

class HalftonesPage extends StatelessWidget {
  const HalftonesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(screenBackground),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
