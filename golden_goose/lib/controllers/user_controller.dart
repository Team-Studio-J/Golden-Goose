import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/user_model.dart';

class UserController extends GetxController {
  Rx<UserModel> _user = UserModel(uid:"",nickname:"", email: "", registrationDate: DateTime.now()).obs;
  Rx<Account> _rankAccount = Account().obs;
  Rx<Account> _unrankAccount = Account().obs;

  UserModel get user => _user.value;

  //Account get rankAccount => _rankAccount.value;
  //Account get unrankAccount => _unrankAccount.value;

  Account ofAccount(AccountType type) {
    switch (type) {
      case AccountType.rank:
        return _rankAccount.value;
      case AccountType.unrank:
        return _unrankAccount.value;
    }
  }

  bindUser() {
    //stream coming from firebase
    _user.bindStream(Database.userStream(Get.find<AuthController>().user!));
    _rankAccount.bindStream(Database.accountStream(
        Get.find<AuthController>().user!, AccountType.rank));
    _unrankAccount.bindStream(Database.accountStream(
        Get.find<AuthController>().user!, AccountType.unrank));
    print(user);
  }
}
