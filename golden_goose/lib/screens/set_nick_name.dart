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
              const Text("닉네임 변경"),
              TextField(
                decoration: InputDecoration(
                  hintText: uc.user.nickname,
                ),
                controller: nicknameController,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "닉네임은 최소 3글자 이상에 오직 문자, 알파벳, 숫자, _(언더바), -(대시) 로만 구성될 수 있습니다",
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
                      child: const Text("취소")),
                  const SizedBox(width: 10),
                  ButtonGrid(
                      color: Colors.indigo.withOpacity(0.8),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      onTap: () => updateNickname(nicknameController.text),
                      child: const Text("변경")),
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
      Get.snackbar("닉네임 에러", "가능한 닉네임이 아닙니다",
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
