import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/user_model.dart';
import 'package:golden_goose/widgets/grid.dart';

class SetNickName extends StatelessWidget {
  SetNickName({Key? key}) : super(key: key);
  final ac = Get.find<AuthController>();
  final uc = Get.find<UserController>();

  final nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Change Nickname".tr),
              TextField(
                decoration: InputDecoration(
                  hintText: uc.user.nickname,
                ),
                controller: nicknameController,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nickname should be consisted with at least 3 alphabets, numbers, _(underscore) or -(dash)".tr,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonGrid(
                      color: Colors.grey,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      onTap: () {
                        Get.back();
                      },
                      child: Text("Cancel".tr)),
                  const SizedBox(width: 10),
                  ButtonGrid(
                      color: Colors.indigo.withOpacity(0.8),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      onTap: () => updateNickname(nicknameController.text),
                      child: Text("Apply".tr)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateNickname(String text) {
    if (!isNicknameOk(text)) {
      Get.snackbar("Error on Nickname".tr, 'It is not possible strings for Nickname'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    UserModel userModel = uc.user;
    userModel.nickname = text;
    Database.updateUser(ac.user!, userModel.toJson());
    Get.back();
  }

  bool isNicknameOk(String text) {
    RegExp exp = RegExp(r"^[a-zA-Z0-9가-힇ㄱ-ㅎㅏ-ㅣぁ-ゔァ-ヴー々〆〤一-龥_-]{3,}$");
    return exp.hasMatch(text);
  }
}
