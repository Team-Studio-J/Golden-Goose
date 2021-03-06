import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/screens/tab_page.dart';

class Login extends StatelessWidget {
  static const String path = "/Login";
  final AuthController ac = Get.find<AuthController>();

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //title: const Text("Login"),
      //),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  const SizedBox(height: 130),
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
              const SizedBox(height: 40),
              Obx(() {
                if (ac.user == null) return Container();
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    //  primary: Colors.blue,
                    onPrimary: Colors.white,
                    primary: Colors.blue,
                  ),
                  icon: const FaIcon(FontAwesomeIcons.chevronRight,
                      color: Colors.white),
                  label: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${ac.user!.email}'),
                    ],
                  ),
                  onPressed: _continueWith,
                );
              }),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  //  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                icon:
                    const FaIcon(FontAwesomeIcons.google, color: Colors.white),
                label: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sign up with google'),
                  ],
                ),
                onPressed: () {
                  _signUpWithGoogle();
                },
              ),
              const SizedBox(height: 200),
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
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dev by ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      )),
                  Text("Team Studio J",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ],
              ),
               */
            ],
          ),
        ),
      ),
    );
  }

  void _continueWith() {
    Get.offAll(() => const TabPage());
  }

  void _signUpWithGoogle() async {
    try {
      if (ac.isLoggedIn) {
        await ac.signOut();
        Get.snackbar("Logout Succeeded".tr, "Successfully Logged Out".tr,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error on signout".tr, "",
          snackPosition: SnackPosition.BOTTOM);
    }

    try{
      await ac.googleLogin();
    } catch(e) {
      Get.snackbar("Login Failed".tr, "Login is not successful".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.snackbar("Login Succeeded".tr, "Successfully Logged In".tr,
        snackPosition: SnackPosition.BOTTOM);
    if (ac.isLoggedIn) {
      _continueWith();
    }
  }
}
