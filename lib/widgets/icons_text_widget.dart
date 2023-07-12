import 'package:flutter/cupertino.dart';
import 'package:recipe_app/widgets/dimensions.dart';
import 'package:recipe_app/widgets/small_text.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const IconText({
    Key? key,
    required this.icon,
    required this.text,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        SizedBox(width: Dimensions.width4), // Adjust the width as needed
        SmallText(text: text),
      ],
    );
  }
}
