import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/screens/login.dart';

class Splash extends StatelessWidget {
  static const String path = "/Splash";

  Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 2000), () {
      // 1
      Get.offAll(() => Login(), transition: Transition.cupertino);
    });
    return Scaffold(
      //appBar: AppBar(
        //title: const Text("Login"),
      //),
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
                      )),
                  Text("Scalpers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      )),
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
