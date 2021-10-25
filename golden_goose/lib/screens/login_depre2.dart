import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome"),
              TextField(
                controller: emailController,
              ),
              TextField(
                controller: passwordController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        //await GetAuthController.authInstance.register( emailController.text, passwordController.text);
                      },
                      child: Text("Sign Up")
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () async {
                        //await GetAuthController.authInstance.login(emailController.text, passwordController.text);
                      },
                      child: Text("Sign In")
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

