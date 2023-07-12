import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/pages/navbar.dart';
import 'package:recipe_app/widgets/app_routes.dart';
import 'package:recipe_app/widgets/dimensions.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final String bio;

  ProfilePage({required this.name, required this.email, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.iconSize16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: Dimensions.height50,
              backgroundColor: Colors.yellow,
              child: Icon(
                Icons.account_circle,
                size: Dimensions.height80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: Dimensions.iconSize16),
            Text(
              'Name: $name',
              style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.radius8),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: Dimensions.iconSize16),
            ),
            SizedBox(height: Dimensions.radius8),
            Text(
              'Bio: $bio',
              style: TextStyle(fontSize: Dimensions.iconSize16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String name = user?.displayName ?? 'John Doe';
    String email = user?.email ?? 'johndoe@example.com';
    String bio = 'I love cooking and trying new recipes!';

    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(primaryColor: Colors.yellow),
      home: ProfilePage(
        name: name,
        email: email,
        bio: bio,
      ),
      onGenerateRoute: AppRoutes.generateRoute, // Add this line to use the custom route generator
      routes: {
        '/profile': (_) => ProfilePage(
          name: name,
          email: email,
          bio: 'I love cooking and trying new recipes!',
        ),
      },
    );
  }
}
