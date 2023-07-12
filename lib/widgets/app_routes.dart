import 'package:flutter/material.dart';
import 'package:recipe_app/pages/create_recipe.dart';
import 'package:recipe_app/pages/login_page.dart';
import 'package:recipe_app/pages/main_food.dart';
import 'package:recipe_app/pages/profile.dart';
import 'package:recipe_app/pages/recipe_page_list.dart';
import 'package:recipe_app/pages/signin.dart';

class AppRoutes {
  static const Duration transitionDuration = Duration(milliseconds: 5);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/home':
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => MainFood(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: transitionDuration,
        );
      case '/recipelist':
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => RecipeList(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: transitionDuration,
        );
      case '/createRecipe':
        return PageRouteBuilder(
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (_, __, ___) => CreateRecipe(),
          transitionDuration: transitionDuration,
        );
      case '/profile':
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => ProfilePage(name: 'John Doe', email: 'johndoe@example.com', bio: 'I love cooking and trying new recipes!',),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: transitionDuration,
        );
      default:
      // Handle unknown routes
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(child: Text('Page not found')),
        ));
    }
  }
}


