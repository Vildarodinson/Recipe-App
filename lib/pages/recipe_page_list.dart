  import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
  import 'package:flutter/material.dart';
  import 'package:recipe_app/pages/navbar.dart';
  import 'package:recipe_app/widgets/big_text.dart';
  import 'package:recipe_app/widgets/color.dart';
  import 'package:recipe_app/widgets/dimensions.dart';
  import 'package:recipe_app/widgets/small_text.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:recipe_app/pages/recipe_detail.dart'; // Import the RecipeDetail page

  class RecipeList extends StatefulWidget {
    const RecipeList({Key? key});

    @override
    State<RecipeList> createState() => _RecipeListState();
  }

  class _RecipeListState extends State<RecipeList> {
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
                  bottom: Dimensions.width5,
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
                        BigText(text: "Recipe"),
                        BigText(text: 'List', size: Dimensions.font14),
                      ],
                    ),
                    Center(
                      child: Container(
                        width: Dimensions.height45,
                        height: Dimensions.height45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
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
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
                    sliver: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SliverToBoxAdapter(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final itemCount = snapshot.data!.docs.length;
                        final List<Widget> containers = [];

                        for (int i = 0; i < itemCount; i += 2) {
                          if (i + 1 < itemCount) {
                            containers.add(
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
                                child: Row(
                                  children: [
                                    buildRecipeContainer(snapshot.data!.docs[i]),
                                    SizedBox(width: Dimensions.width20),
                                    buildRecipeContainer(snapshot.data!.docs[i + 1]),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            containers.add(
                              Padding(
                                padding: EdgeInsets.only(bottom: Dimensions.height10),
                                child: buildRecipeContainer(snapshot.data!.docs[i]),
                              ),
                            );
                          }
                        }

                        return SliverList(
                          delegate: SliverChildListDelegate(containers),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Navbar(),
      );
    }

    Future<String> getImageUrl(String imageName) async {
      // Retrieve the image URL from Firebase Storage based on the provided image name
      try {
        final ref = firebase_storage.FirebaseStorage.instance.ref().child('recipe_images/$imageName');
        final url = await ref.getDownloadURL();
        return url;
      } catch (e) {
        print('Error retrieving image URL: $e');
        return ''; // Return an empty string if there is an error
      }
    }

    Widget buildRecipeContainer(DocumentSnapshot<Object?> doc) {
      final data = doc.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('time')) {
        final time = (data['time'] as num).toInt(); // Convert time to an integer
        final timetype = data['timetype'] as String? ?? '';
        final String name = doc['name'];
        final cal = data['cal'] as int;
        final difficulty = data['difficulty'] as String? ?? '';
        final serving = data['serving'] as int;

        final imageName = name.toLowerCase().replaceAll(' ', '') + '.jpg'; // Convert name to lowercase and remove spaces

        return FutureBuilder<String>(
          future: getImageUrl(imageName), // Use the updated image name
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the image URL, display a placeholder container
              return Container(
                margin: EdgeInsets.only(
                  left: Dimensions.width5,
                  right: Dimensions.width5,
                  bottom: Dimensions.height10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: Dimensions.width185,
                      height: Dimensions.height300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius30),
                        color: AppColor.FoodBody1,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(left: Dimensions.width10),
                        child: BigText(text: name, color: Colors.black),
                      ),
                    ),
                    buildIconsRow(time, timetype),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              print('Error loading image: ${snapshot.error}');
            }

            final imageUrl = snapshot.data ?? '';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetail(
                      recipeId: doc.id,
                      name: name,
                      time: time,
                      timetype: timetype,
                      cal: cal,
                      difficulty: difficulty,
                      serving: serving,
                      imageURL: imageUrl.isNotEmpty ? imageUrl : "assets/images/food-product.jpg",
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: Dimensions.width5,
                  right: Dimensions.width5,
                  bottom: Dimensions.width5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: Dimensions.width185,
                          height: Dimensions.height300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius30),
                            color: AppColor.FoodBody1,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageUrl.isNotEmpty ? NetworkImage(imageUrl!) as ImageProvider<Object> : AssetImage("assets/images/food-product.jpg"),
                            ),
                          ),
                        ),
                        Positioned(
                          top: Dimensions.height3,
                          left: Dimensions.width10,
                          child: buildTimeIcon(time, timetype),
                        ),
                        Positioned(
                          bottom: Dimensions.height10,
                          right: Dimensions.width10,
                          child: buildRatingIcon(),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Container(
                      padding: EdgeInsets.all(Dimensions.width10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Dimensions.radius30),
                          bottomRight: Radius.circular(Dimensions.radius30),
                        ),
                      ),
                      child: BigText( text: name, color: Colors.black),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }

      return SizedBox(); // Return an empty container if the 'time' field is missing or not an integer
    }

    Widget buildTimeIcon(num time, String timetype) {
      return Container(
        margin: EdgeInsets.all(Dimensions.width10),
        padding: EdgeInsets.all(Dimensions.width4),
        decoration: BoxDecoration(
          color: AppColor.translucentBlack,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time_rounded, color: Colors.white, size: Dimensions.iconSize16),
            SizedBox(width: Dimensions.width4),
            Text('$time', style: TextStyle(color: Colors.white)),
            Text('$timetype', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    Widget buildRatingIcon() {
      return Container(
        margin: EdgeInsets.all(Dimensions.width10),
        padding: EdgeInsets.all(Dimensions.width4),
        decoration: BoxDecoration(
          color: AppColor.translucentYellow,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Row(
          children: [
            Icon(Icons.star, color: Colors.black, size: Dimensions.iconSize16),
            SizedBox(width: Dimensions.width4),
            Text('5.0', style: TextStyle(color: Colors.black)),
          ],
        ),
      );
    }

    Widget buildIconsRow(num time, String timetype) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTimeIcon(time, timetype),
          buildRatingIcon(),
        ],
      );
    }
  }
