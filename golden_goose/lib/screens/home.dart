import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';

class Home extends StatelessWidget {
  static const String path = "/Home";
  final uc = Get.find<UserController>();

  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child:
      Center(child: Column(
        children: [
          Text("Hello World"),
          Obx(() => Text("user id : ${uc.user.id}")),
          Obx(() => Text("user email : ${uc.user.email}")),
          Obx(() => Text("user nickname : ${uc.user.nickname}")),
          Obx(() => Text("user money : ${uc.user.money}")),
        ],
      ))),
    );
  }
}
