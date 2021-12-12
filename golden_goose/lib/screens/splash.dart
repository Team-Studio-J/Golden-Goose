import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/screens/login.dart';
import 'package:golden_goose/screens/tab_page.dart';

class Splash extends StatelessWidget {
  static const String path = "/Splash";

  final AuthController ac = Get.find<AuthController>();

  Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (ac.isLoggedIn) {
        Get.offAll(() => const TabPage(), transition: Transition.cupertino);
        return;
      }
      Get.offAll(() => Login(), transition: Transition.cupertino);
    });
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const SizedBox(height: 130),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Short",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontFamily: 'NextArt')),
                  Text("Scalpers",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontFamily: 'NextArt')),
                ],
              ),
              const SizedBox(height: 400),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text("Developed By",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      )),
                  Text("TEAM STUDIO J",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
