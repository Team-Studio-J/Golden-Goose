import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/user_model.dart';
import 'package:golden_goose/screens/splash.dart';
import 'package:golden_goose/widgets/grid.dart';

import 'login.dart';

class SetWithdrawal extends StatelessWidget {
  SetWithdrawal({Key? key}) : super(key: key);
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
              Text("Membership Withdrawal".tr),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Membership Withdrawal Information".tr,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
                      color: Colors.red.withOpacity(0.8),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      onTap: () => deleteUser(),
                      child: Text("Delete".tr)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteUser() async {
    String uid = ac.user!.uid;
    ac.isOnDeleting = true;
    try{
      await ac.signOut();
      await ac.googleLogin();
      if (ac.user != null) {
        if(ac.user!.uid == uid) {
          await ac.auth.currentUser!.delete();
          Get.snackbar("Membership Withdrawal".tr,
              "Membership Withdrawal is successful".tr, snackPosition: SnackPosition.BOTTOM);
          ac.isOnDeleting = false;
          Get.offAll(() => Login());
          return;
        }
        await ac.signOut();
        throw('Please login again with same user to withdrawal'.tr);
      }
      throw('Please login again to withdrawal'.tr);
    } catch (e){
      e.printError();
      Get.snackbar("Membership Withdrawal".tr,
          e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      ac.isOnDeleting = false;
      Get.offAll(() => Login());
    }
  }

  bool isNicknameOk(String text) {
    RegExp exp = RegExp(r"^[a-zA-Z0-9가-힇ㄱ-ㅎㅏ-ㅣぁ-ゔァ-ヴー々〆〤一-龥_-]{3,}$");
    return exp.hasMatch(text);
  }
}
