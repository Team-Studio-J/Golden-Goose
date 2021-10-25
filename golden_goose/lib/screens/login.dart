import 'package:firebase_auth/firebase_auth.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


class Login extends StatelessWidget {
  static const String path = "/Login";
  final GetAuthController ac = Get.find<GetAuthController>();
_showSnackBar(String msg) {
    Get.snackbar(
      "GoldGoose",
      msg,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              /*
              Row(
                children: [
                  Text("profile"),
                  Obx( () => ac.user != null && ac.user!.photoURL != null ?
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(ac.user!.photoURL!),
                  ) : const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.people),
                  )),
                  Obx(() => ac.user != null && ac.user!.email != null ?
                  Text(ac.user!.email!) : Text("Empty")),
                ],
              ),
               */
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Short", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  )),
                  Text("Scalpers", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  )),
                ],
              ),
              SizedBox(height: 40),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                      //  primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                      label: Text('Sign Up with Google'),
                      onPressed: () async {
                        ac.googleLogin();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
