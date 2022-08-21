import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/halftones/styles.dart';
import 'package:nerdvalorant/themes/global_styles.dart';

class SearchHalftone extends StatefulWidget {
  final String text;
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchHalftone({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  State<SearchHalftone> createState() => _SearchHalftoneState();
}

class _SearchHalftoneState extends State<SearchHalftone> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: ScreenSize.height(5.5),
      margin: EdgeInsets.fromLTRB(
        ScreenSize.width(1),
        ScreenSize.width(2),
        ScreenSize.width(1),
        ScreenSize.width(2),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: whiteColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.width(1),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(
            Ionicons.search_outline,
            color: style.color,
            size: 32,
          ),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(
                    Ionicons.close_outline,
                    color: style.color,
                    size: 32,
                  ),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
