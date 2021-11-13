import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/user.dart';

class UserController extends GetxController {
  Rx<UserModel> _user = UserModel().obs;
  UserModel get user => _user.value;

  bindUser() {
    String uid = Get.find<AuthController>().user!.uid;
    _user.bindStream(Database().userStream(uid)); //stream coming from firebase
  }
}