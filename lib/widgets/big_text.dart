import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/color.dart';
import 'package:recipe_app/widgets/dimensions.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  FontWeight fontWeight;
  TextOverflow overflow;
  BigText({super.key,
    this.color,
    this.size=0,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.overflow=TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        color: color ?? AppColor.BigTextColor,
        fontSize: size==0?Dimensions.font20:size,
        fontWeight: fontWeight,
      ),
    );
  }
}

