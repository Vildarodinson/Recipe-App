import 'package:flutter/material.dart';
import 'package:recipe_app/pages/food_page_body.dart';
import 'package:recipe_app/pages/navbar.dart';
import 'package:recipe_app/widgets/big_text.dart';
import 'package:recipe_app/widgets/dimensions.dart';
import 'package:recipe_app/widgets/small_text.dart';

class MainFood extends StatefulWidget {
  const MainFood({Key? key});

  @override
  State<MainFood> createState() => _MainFoodState();
}

class _MainFoodState extends State<MainFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(
                top: Dimensions.height45,
                bottom: Dimensions.height15,
              ),
              padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BigText(text: "Country"),
                      Row(
                        children: [
                          SmallText(text: 'City'),
                          Icon(Icons.arrow_drop_down_rounded),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: Dimensions.height45,
                      height: Dimensions.height45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.radius15),
                        color: Color(0xFF36b3a0),
                      ),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FoodBody(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}