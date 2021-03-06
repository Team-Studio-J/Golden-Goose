import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/repositories/locale_string.dart';
import 'package:golden_goose/screens/chart.dart';
import 'package:golden_goose/screens/home.dart';
import 'package:golden_goose/screens/login.dart';
import 'package:golden_goose/screens/my_page.dart';
import 'package:golden_goose/screens/rank.dart';
import 'package:golden_goose/screens/splash.dart';
import 'package:golden_goose/theme_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController(), permanent: true);
    Get.put(UserController(), permanent: true);
  });
  Get.testMode = true;
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
      locale: Get.deviceLocale,
      //locale: const Locale('en', 'US'),


      fallbackLocale: const Locale('en', 'US'),
      translations: LocaleString(),
      home: Splash(),
      getPages: [
        GetPage(page: () => Splash(), name: Splash.path),
        GetPage(page: () => Login(), name: Login.path),
        GetPage(page: () => Home(), name: Home.path),
        GetPage(page: () => Chart(), name: Chart.path),
        GetPage(page: () => const Rank(), name: Rank.path),
        GetPage(page: () => const MyPage(), name: MyPage.path),
      ],
    );
  }
}
