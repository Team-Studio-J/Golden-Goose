import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                //GetAuthController.authInstance.signOut();
              },
              icon: const Icon(Icons.power_off)
          ),
        ]
      ),
      body: const Center(
        child: Text("Home"),
      ),
    );
  }
}
