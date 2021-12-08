import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/screens/chart.dart';
import 'package:golden_goose/screens/home.dart';
import 'package:golden_goose/screens/login.dart';
import 'package:golden_goose/screens/my_page.dart';
import 'package:golden_goose/screens/rank.dart';
import 'package:golden_goose/screens/splash.dart';
import 'package:golden_goose/theme_data.dart';

import 'controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController(), permanent: true);
    Get.put(UserController(), permanent: true);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Short Scalpers",
      theme: GoldenGooseThemeData.value,
      home: const Splash(),
      getPages: [
        GetPage(page: () => const Splash(), name: Splash.path),
        GetPage(page: () => Login(), name: Login.path),
        GetPage(page: () => Home(), name: Home.path),
        GetPage(page: () => Chart(), name: Chart.path),
        GetPage(page: () => const Rank(), name: Rank.path),
        GetPage(page: () => const MyPage(), name: MyPage.path),
      ],
    );
  }
}
