import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/app_icons.dart';
import 'package:recipe_app/widgets/big_text.dart';
import 'package:recipe_app/widgets/color.dart';
import 'package:recipe_app/widgets/dimensions.dart';
import 'package:recipe_app/widgets/small_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDetail extends StatelessWidget {
  final String name;
  final String recipeId;
  final num time;
  final String timetype;
  final String imageURL;
  final int cal;
  final String difficulty;
  final int serving;

  const RecipeDetail({
    Key? key,
    required this.name,
    required this.time,
    required this.timetype,
    required this.imageURL,
    required this.recipeId,
    required this.cal,
    required this.difficulty,
    required this.serving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: Dimensions.height15),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: Dimensions.height300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageURL.isNotEmpty ? NetworkImage(imageURL) as ImageProvider<Object> : AssetImage("assets/images/food-product.jpg"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: AppIcon(
                              icon: Icons.arrow_back_ios,
                            ),
                          ),
                          AppIcon(icon: Icons.bookmark_border),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(Dimensions.width20, Dimensions.height30, Dimensions.width20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: name,
                      color: Colors.black,
                      size: Dimensions.height30,
                    ),
                    AppIcon(
                      icon: Icons.star,
                      iconColor: Colors.black,
                      backgroundColor: AppColor.AppIconBackground,
                      text: "5.0",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(Dimensions.width15, Dimensions.height10, Dimensions.width15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimensions.height15, Dimensions.height15, Dimensions.height15, Dimensions.height20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.height40),
                        color: AppColor.AppBack,
                      ),
                      child: Column(
                        children: [
                          AppIcon(
                            icon: Icons.access_time_rounded,
                            backgroundColor: Colors.white,
                            size: Dimensions.height50,
                            iconSize: Dimensions.height35,
                          ),
                          SizedBox(height: Dimensions.width5),
                          SmallText(
                            text: time.toString(),
                            size: Dimensions.height25,
                          ),
                          SmallText(
                            text: timetype,
                            size: Dimensions.height25,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimensions.height15, Dimensions.height15, Dimensions.height15, Dimensions.height20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.height40),
                        color: AppColor.AppBack,
                      ),
                      child: Column(
                        children: [
                          AppIcon(
                            icon: Icons.groups_2_rounded,
                            backgroundColor: Colors.white,
                            size: Dimensions.height50,
                            iconSize: Dimensions.height35,
                          ),
                          SizedBox(height: Dimensions.width5),
                          SmallText(
                            text: serving.toString(),
                            size: Dimensions.height25,
                          ),
                          SmallText(
                            text: "Servings",
                            size: Dimensions.height15,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimensions.height15, Dimensions.height15, Dimensions.height15, Dimensions.height20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.height40),
                        color: AppColor.AppBack,
                      ),
                      child: Column(
                        children: [
                          AppIcon(
                            icon: Icons.whatshot,
                            backgroundColor: Colors.white,
                            size: Dimensions.height50,
                            iconSize: Dimensions.height35,
                          ),
                          SizedBox(height: Dimensions.width5),
                          SmallText(
                            text: cal.toString(),
                            size: Dimensions.height25,
                          ),
                          SmallText(
                            text: "Cal",
                            size: Dimensions.height15,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimensions.height15, Dimensions.height15, Dimensions.height15, Dimensions.height20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.height40),
                        color: AppColor.AppBack,
                      ),
                      child: Column(
                        children: [
                          AppIcon(
                            icon: Icons.layers,
                            backgroundColor: Colors.white,
                            size: Dimensions.height50,
                            iconSize: Dimensions.height35,
                          ),
                          SizedBox(height: Dimensions.width5),
                          SmallText(
                            text: difficulty,
                            size: Dimensions.height20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: Dimensions.width15),
                  child: BigText(
                    text: "Ingredients:",
                    color: Colors.black,
                    size: Dimensions.font22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('recipes')
              .doc(recipeId)
              .collection('ingredientAmounts')
              .doc('ingredientAmounts')
              .snapshots(),
          builder: (context, ingredientAmountsSnapshot) {
            if (ingredientAmountsSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final ingredientAmountsData = ingredientAmountsSnapshot.data?.data() as Map<String, dynamic>?;

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recipes')
                  .doc(recipeId)
                  .collection('Ingredients')
                  .doc('Ingredients')
                  .snapshots(),
              builder: (context, ingredientsSnapshot) {
                if (ingredientsSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final ingredientData = ingredientsSnapshot.data?.data() as Map<String, dynamic>?;

                final ingredientList = [];
                for (int i = 1; i <= 4; i++) {
                  final ingredientName = ingredientData?['Ingredient$i'];
                  final ingredientAmount = ingredientAmountsData?['Amount$i']?.toString(); // Convert to string

                  ingredientList.add({
                    'name': ingredientName,
                    'amount': ingredientAmount,
                  });
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: Dimensions.height15), // Adjusted top padding
                  itemCount: ingredientList.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredientList[index];
                    final ingredientName = ingredient['name'];
                    final ingredientAmount = ingredient['amount'];

                    return Padding(
                      padding: EdgeInsets.only(left: Dimensions.height20),
                      child: Row(
                        children: [
                          Icon(Icons.circle_sharp, size: Dimensions.height15, color: AppColor.AppBack),
                          SizedBox(width: Dimensions.width10),
                          BigText(
                            text: ingredientAmount ?? '',
                            size: Dimensions.height20,
                            color: Colors.black,
                          ),
                          SizedBox(width: Dimensions.width5),
                          SmallText(
                            text: ingredientName ?? '',
                            size: Dimensions.height15,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
            SizedBox(height: Dimensions.height20),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: Dimensions.width15),
                  child: BigText(
                    text: "Directions:",
                    color: Colors.black,
                    size: Dimensions.font22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('recipes')
                    .doc(recipeId)
                    .collection('Directions')
                    .doc('Directions')
                    .snapshots(),
                builder: (context, directionsSnapshot) {
                  if (directionsSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final directionsData = directionsSnapshot.data?.data() as Map<String, dynamic>?;

                  if (directionsData == null || directionsData.isEmpty) {
                    return Text('No directions found');
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: Dimensions.height10), // Adjusted top padding
                    itemCount: directionsData.length,
                    itemBuilder: (context, index) {
                      final fieldName = 'Direction${index + 1}';
                      final direction = directionsData[fieldName];
                      return Padding(
                        padding: EdgeInsets.only(left: Dimensions.height20, top: Dimensions.height15),
                        child: Row(
                          children: [
                            Icon(Icons.circle_sharp, size: Dimensions.height15, color: AppColor.AppBack),
                            SizedBox(width: Dimensions.width10),
                            SmallText(
                              text: direction ?? '',
                              size: Dimensions.height15,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

