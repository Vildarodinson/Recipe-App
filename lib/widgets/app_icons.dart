import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/big_text.dart';
import 'package:recipe_app/widgets/dimensions.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final String? text;

  static const double defaultIconSize = 18.0;

  AppIcon({
    Key? key,
    required this.icon,
    this.backgroundColor = const Color(0xFffcf4e4),
    this.iconColor = const Color(0xFF756d54),
    this.size = 40,
    this.iconSize = defaultIconSize,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    double totalWidth = size;
    double textMargin = 0.0;
    if (text != null) {
      final textWidth = TextPainter(
        text: TextSpan(
          text: text!,
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.font14,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      totalWidth += textWidth.width + iconSize;
      textMargin = Dimensions.height10 / 2; // Adjust the margin here
    }

    return Container(
      width: totalWidth,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
          if (text != null)
            Container(
              margin: EdgeInsets.only(left: textMargin),
              child: BigText(
                text: text!,
                color: Colors.black,
                size: Dimensions.font14,
              ),
            ),
        ],
      ),
    );
  }
}
