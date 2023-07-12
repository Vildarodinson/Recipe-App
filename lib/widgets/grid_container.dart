import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/big_text.dart';
import 'package:recipe_app/widgets/color.dart';
import 'package:recipe_app/widgets/dimensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeCard extends StatelessWidget {
  final QueryDocumentSnapshot recipes;

  const RecipeCard({required this.recipes});

  @override
  Widget build(BuildContext context) {
    print('RecipeCard - recipes: $recipes');
    final Map<String, dynamic>? data = recipes.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
    final String name = data?['name'] ?? ''; // Access the 'name' field using the index operator []
    final int time = data?['time'] ?? 0;

    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: Dimensions.height10),
            width: Dimensions.width185,
            height: Dimensions.height300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: AppColor.FoodBody1,
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/food-product.jpg"),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    margin: EdgeInsets.all(Dimensions.width10),
                    padding: EdgeInsets.all(Dimensions.width4),
                    decoration: BoxDecoration(
                      color: AppColor.translucentBlack,
                      borderRadius: BorderRadius.circular(Dimensions.radius8),
                    ),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_rounded, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text("30", style: TextStyle(color: Colors.white)),
                          Text('min', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    margin: EdgeInsets.all(Dimensions.width10),
                    padding: EdgeInsets.all(Dimensions.width4),
                    decoration: BoxDecoration(
                      color: AppColor.translucentYellow,
                      borderRadius: BorderRadius.circular(Dimensions.radius8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.black, size: 16),
                        SizedBox(width: 4),
                        Text('5.0', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: BigText(text: "Name", color: Colors.black),
            alignment: Alignment.bottomLeft,
          )
        ],
      ),
    );
  }
}