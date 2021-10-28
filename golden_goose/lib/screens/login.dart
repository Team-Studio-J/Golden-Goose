import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/screens/splash.dart';
import 'package:golden_goose/screens/tab_page.dart';

class Login extends StatelessWidget {
  static const String path = "/Login";
  final AuthController ac = Get.find<AuthController>();

  Login({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              const SizedBox(height: 40),
              Obx(() {
                if (ac.user == null) return Container();
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    //  primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  icon: const FaIcon(FontAwesomeIcons.chevronRight,
                      color: Colors.white),
                  label: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Continue With'),
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
                icon: const FaIcon(FontAwesomeIcons.google,
                    color: Colors.white),
                label: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sign Up With Google'),
                  ],
                ),
                onPressed: () {
                  _signUpWithGoogle();
                },
              ),

              ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                //  primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              icon: const FaIcon(FontAwesomeIcons.chevronLeft,
                  color: Colors.white),
              label: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('return'),
                ],
              ),
              onPressed: () {Get.offAll(() => Splash());},
            ),
              const SizedBox(height: 430),

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
    Get.offAll(() => TabPage());
  }

  void _signUpWithGoogle() async {
    await ac.signOut();
    await ac.googleLogin();
    if (ac.isLoggedIn) {
      _continueWith();
    }
  }
}
