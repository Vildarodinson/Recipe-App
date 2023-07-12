import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/color.dart';
import 'package:recipe_app/widgets/dimensions.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  SmallText({super.key,
    this.color,
    this.size=0,
    required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? AppColor.SmallTextColor,
          fontSize:size==0?Dimensions.font14:size,
      ),
    );
  }
}
