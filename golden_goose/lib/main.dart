import 'package:golden_goose/Constants/auth_constant.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/screens/home.dart';
import 'package:golden_goose/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:golden_goose/theme_data.dart';

import 'Constants/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization.then((value) {
    Get.put(GetAuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.title,
      theme: GoldenGooseThemeData.value,
      home: Login(),
      getPages: [
        GetPage(page: () => Home(), name: Home.path),
        GetPage(page: () => Login(), name: Login.path),
      ],
    );
  }
}

