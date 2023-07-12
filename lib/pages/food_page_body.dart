import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/pages/recipe_detail.dart';
import 'package:recipe_app/pages/recipe_page_list.dart';
import 'package:recipe_app/widgets/big_text.dart';
import 'package:recipe_app/widgets/color.dart';
import 'package:recipe_app/widgets/dimensions.dart';
import 'package:recipe_app/widgets/icons_text_widget.dart';
import 'package:recipe_app/widgets/small_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FoodBody extends StatefulWidget {
  const FoodBody({Key? key}) : super(key: key);

  @override
  State<FoodBody> createState() => _FoodBodyState();
}

List<String> imageUrls = [];

class _FoodBodyState extends State<FoodBody> {
  bool _isGridViewLoaded = false;
  late Widget _gridView;
  late Stream<QuerySnapshot> _recipeStream;
  PageController pageController = PageController(viewportFraction: 0.88);
  var _currentPage = 0.0;
  double _scaleFac = 0.8;
  double height = Dimensions.pageViewCon;

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!;
      });
    });
    _recipeStream = FirebaseFirestore.instance.collection('recipes').snapshots();
    _gridView = StreamBuilder<QuerySnapshot>(
      stream: _recipeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final recipes = snapshot.data!.docs;
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final data = recipe.data() as Map<String, dynamic>;
              final name = data['name'] as String;
              final time = (data['time'] as num).toInt(); // Convert time to an integer
              final timetype = data['timetype'] as String;

              return FutureBuilder<String>(
                future: getImageURL(recipe),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  String image = snapshot.data ?? 'assets/images/food-product.jpg';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetail(
                            recipeId: recipe.id,
                            name: name,
                            time: time,
                            timetype: timetype,
                            imageURL: image,
                            cal: data['cal'] as int,
                            difficulty: data['difficulty'] as String,
                            serving: data['serving'] as int,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.width10),
                      child: Stack(
                        children: [
                          Container(
                            width: Dimensions.width190,
                            height: Dimensions.height300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius30),
                              color: index.isEven ? AppColor.FoodBody1 : AppColor.FoodBody2,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radius30),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/food-product.jpg',
                                image: image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            top: Dimensions.height3,
                            left: Dimensions.width10,
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
                                    Icon(Icons.access_time_rounded, color: Colors.white, size: Dimensions.iconSize16),
                                    SizedBox(width: Dimensions.width4),
                                    Text('${time}', style: TextStyle(color: Colors.white)),
                                    Text('${timetype}', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: Dimensions.height40,
                            right: Dimensions.width10,
                            child: Container(
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
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.width10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(Dimensions.radius30),
                                  bottomRight: Radius.circular(Dimensions.radius30),
                                ),
                              ),
                              child: Align(alignment: Alignment.center, child: BigText(text: name, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
    _isGridViewLoaded = true;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Future<String> getImageURL(DocumentSnapshot recipe) async {
    final data = recipe.data() as Map<String, dynamic>;
    final name = data['name'] as String;
    final imageName = name.toLowerCase().replaceAll(' ', '') + '.jpg';
    final imageURL = await firebase_storage.FirebaseStorage.instance.ref('recipe_images/$imageName').getDownloadURL();
    return imageURL;
  }

  Future<void> _fetchImageUrls() async {
    final snapshot = await FirebaseFirestore.instance.collection('recipes').get();
    final recipes = snapshot.docs;

    final List<Future<String>> futures = [];
    for (final recipe in recipes) {
      futures.add(getImageURL(recipe));
    }

    final List<String> urls = await Future.wait(futures);
    setState(() {
      imageUrls = urls;
    });
  }

  double totalContainerHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    totalContainerHeight = Dimensions.height300 * 5;
    return Column(
      children: [
        Column(
          children: [
            Container(
              height: Dimensions.height320,
              child: StreamBuilder<QuerySnapshot>(
                stream: _recipeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final recipes = snapshot.data!.docs;
                    return PageView.builder(
                      controller: pageController,
                      itemCount: 5,
                      itemBuilder: (context, position) {
                        if (position < imageUrls.length) {
                          final recipe = recipes[position];
                          final data = recipe.data() as Map<String, dynamic>;
                          final name = data['name'] as String;
                          final time = (data['time'] as num).toInt(); // Convert time to an integer
                          final timetype = data['timetype'] as String;
                          final serving = data['serving'] as int;
                          final difficulty = data['difficulty'] as String;

                          return _buildItem(position, name, imageUrls[position], time, timetype, serving, difficulty);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            DotsIndicator(
              dotsCount: 5,
              position: _currentPage,
              decorator: DotsDecorator(
                activeColor: AppColor.BigTextColor,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius5),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height30),
            Container(
              margin: EdgeInsets.only(left: Dimensions.width15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BigText(
                    text: "Popular",
                    color: Colors.black,
                    size: Dimensions.font25,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height3),
                    child: SmallText(text: ".", size: Dimensions.font25),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height3),
                    child: SmallText(text: "Top 5"),
                  )
                ],
              ),
            ),
            _isGridViewLoaded
                ? _gridView
                : StreamBuilder<QuerySnapshot>(
              stream: _recipeStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final recipes = snapshot.data!.docs;
                  _gridView = GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      final data = recipe.data() as Map<String, dynamic>;
                      final name = data['name'] as String;
                      final time = (data['time'] as num).toInt(); // Convert time to an integer
                      final timetype = data['timetype'] as String;
                      final serving = data['serving'] as int;
                      final difficulty = data['difficulty'] as String;

                      return FutureBuilder<String>(
                        future: getImageURL(recipe),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          String image = snapshot.data ?? 'assets/images/food-product.jpg';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetail(
                                    recipeId: recipe.id,
                                    name: name,
                                    time: time,
                                    timetype: timetype,
                                    imageURL: image,
                                    cal: data['cal'] as int,
                                    difficulty: data['difficulty'] as String,
                                    serving: data['serving'] as int,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.width10),
                              child: Stack(
                                children: [
                                Container(
                                width: Dimensions.width190,
                                height: Dimensions.height300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  color: index.isEven ? AppColor.FoodBody1 : AppColor.FoodBody2,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/food-product.jpg',
                                    image: image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: Dimensions.height3,
                                left: Dimensions.width10,
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
                                      Icon(Icons.access_time_rounded, color: Colors.white, size: Dimensions.iconSize16),
                                      SizedBox(width: Dimensions.width4),
                                      Text('${time}', style: TextStyle(color: Colors.white)),
                                      Text('${timetype}', style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: Dimensions.height40,
                              right: Dimensions.width10,
                              child: Container(
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
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(Dimensions.width10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(Dimensions.radius30),
                                    bottomRight: Radius.circular(Dimensions.radius30),
                                  ),
                                ),
                                child: Align(alignment: Alignment.center, child: BigText(text: name, color: Colors.black)),
                              ),
                            ),
                            ],
                          ),
                          ),
                          );
                        },
                      );
                    },
                  );

                  setState(() {
                    _isGridViewLoaded = true;
                  });
                  return _gridView;
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItem(int index, String name, String imageURL, num time, String timetype, int serving, String difficulty) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currentPage.floor()) {
      var currScale = 1 - (_currentPage - index) * (1 - _scaleFac);
      var _currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _currTrans, 0);
    } else if (index == _currentPage.floor() + 1) {
      var currScale = _scaleFac + (_currentPage - index + 1) * (1 - _scaleFac);
      var _currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _currTrans, 0);
    } else if (index == _currentPage.floor() - 1) {
      var currScale = 1 - (_currentPage - index) * (1 - _scaleFac);
      var _currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _currTrans, 0);
    } else {
      var currScale = _scaleFac;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, height * (1 - _scaleFac) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: height,
            margin: EdgeInsets.only(left: Dimensions.width5, right: Dimensions.width5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: index.isEven ? AppColor.FoodBody1 : AppColor.FoodBody2,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageURL),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextCon,
              margin: EdgeInsets.only(left: Dimensions.width40, right: Dimensions.width40, bottom: Dimensions.height13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFe8e8e8),
                    blurRadius: 5.0,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Container(
                padding: EdgeInsets.only(top: Dimensions.height15, left: Dimensions.height15, right: Dimensions.height15),
                child: Column(
                  children: [
                    BigText(text: name, color: Colors.black),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      children: [
                        Wrap(
                          children: List.generate(
                            5,
                                (index) => Icon(Icons.star, color: AppColor.BigTextColor),
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        SmallText(text: "5.0"),
                        SizedBox(width: Dimensions.width15),
                        SmallText(text: "10"),
                        SizedBox(width: Dimensions.width4),
                        SmallText(text: "comments"),
                      ],
                    ),
                    SizedBox(height: Dimensions.height20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: IconText(
                            icon: Icons.circle_sharp,
                            text: '$difficulty',
                            iconColor: AppColor.EasyIcon,
                          ),
                        ),
                        Container(
                          child: IconText(
                            icon: Icons.groups_2_rounded,
                            text: '$serving',
                            iconColor: AppColor.EasyIcon,
                          ),
                        ),
                        Container(
                          child: IconText(
                            icon: Icons.access_time_rounded,
                            text: "${time.toString()} $timetype",
                            iconColor: AppColor.EasyIcon,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

