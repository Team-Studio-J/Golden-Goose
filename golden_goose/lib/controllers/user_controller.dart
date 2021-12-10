import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel> _user = UserModel(
          uid: "", nickname: "", email: "", registrationDate: DateTime.now())
      .obs;
  final Rx<Account> _rankAccount = Account().obs;
  final Rx<Account> _unrankAccount = Account().obs;
  final RxList<GameResultModel> _rankGameResultModel = <GameResultModel>[].obs;
  final RxList<GameResultModel> _unrankGameResultModel =
      <GameResultModel>[].obs;

  UserModel get user => _user.value;

  Account ofAccount(AccountType type) {
    switch (type) {
      case AccountType.rank:
        return _rankAccount.value;
      case AccountType.unrank:
        return _unrankAccount.value;
    }
  }

  List<GameResultModel> ofResults(AccountType type) {
    switch (type) {
      case AccountType.rank:
        return _rankGameResultModel;
      case AccountType.unrank:
        return _unrankGameResultModel;
    }
  }

  GameResultModel? ofLastResult(AccountType type) {
    switch (type) {
      case AccountType.rank:
        return _rankGameResultModel.isNotEmpty ? _rankGameResultModel[0] : null;
      case AccountType.unrank:
        return _unrankGameResultModel.isNotEmpty
            ? _unrankGameResultModel[0]
            : null;
    }
  }

  bindUser() {
    _user.bindStream(Database.userStream(Get.find<AuthController>().user!));
    _rankAccount.bindStream(Database.accountStream(
        Get.find<AuthController>().user!, AccountType.rank));
    _unrankAccount.bindStream(Database.accountStream(
        Get.find<AuthController>().user!, AccountType.unrank));
    _rankGameResultModel.bindStream(Database.gameResultModelStream(
        Get.find<AuthController>().user!, AccountType.rank));
    _unrankGameResultModel.bindStream(Database.gameResultModelStream(
        Get.find<AuthController>().user!, AccountType.unrank));
  }
}
