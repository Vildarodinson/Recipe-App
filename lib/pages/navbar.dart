import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/color.dart';


class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.AppBack,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.local_dining),
              onPressed: () {
                Navigator.pushNamed(context, '/recipelist');
              },
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/createRecipe');
              },
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
    );
  }
}
