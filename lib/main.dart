import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:recipe_app/pages/login_page.dart';
import 'package:recipe_app/pages/main_food.dart';
import 'package:recipe_app/pages/recipe_page_list.dart';
import 'package:recipe_app/widgets/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: LoginPage(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
