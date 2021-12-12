import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/models/rank_model.dart';
import 'package:golden_goose/models/user_model.dart';
import 'package:country_picker/country_picker.dart';

class Database {
  static final CollectionReference<Map<String, dynamic>> _user =
      FirebaseFirestore.instance.collection('user');
  static final CollectionReference<Map<String, dynamic>> _rankAccount =
      FirebaseFirestore.instance.collection('rankAccount');
  static final CollectionReference<Map<String, dynamic>> _unrankAccount =
      FirebaseFirestore.instance.collection('unrankAccount');
  static final CollectionReference<Map<String, dynamic>> _rank =
      FirebaseFirestore.instance.collection('rank');
  static final CollectionReference<Map<String, dynamic>> _rankHistory =
      FirebaseFirestore.instance.collection('rankHistory');
  static final CollectionReference<Map<String, dynamic>> _unrankHistory =
      FirebaseFirestore.instance.collection('unrankHistory');

  static CollectionReference<Map<String, dynamic>> get user => _user;

  static Stream<UserModel> userStream(User user) {
    return _user.doc(user.uid).snapshots().map<UserModel>((documentSnapshot) {
      if (documentSnapshot.exists) {
        return UserModel.fromDocumentSnapshot(
            documentSnapshot: documentSnapshot);
      }

      var deviceLocale = Get.deviceLocale;
      Country? country;
      if (deviceLocale != null && deviceLocale.countryCode != null) {
        country = Country.tryParse(deviceLocale.countryCode!);
        country?.countryCode;
      }

      UserModel defaultUser = UserModel(
        uid: user.uid,
        email: user.email!,
        nickname: user.email!.split("@").first,
        registrationDate: DateTime.now(),
        nation: country?.countryCode,
      );

      _user.doc(user.uid).set(defaultUser.toJson());
      return defaultUser;
    }).cast();
  }

  static Stream<Account> accountStream(User user, AccountType type) {
    CollectionReference<Map<String, dynamic>> accountRef =
        type == AccountType.rank ? _rankAccount : _unrankAccount;
    return accountRef
        .doc(user.uid)
        .snapshots()
        .map<Account>((documentSnapshot) {
      if (documentSnapshot.exists) {
        return Account.fromDocumentSnapshot(documentSnapshot: documentSnapshot);
      }
      accountRef.doc(user.uid).set(Account().toJson());
      return Account();
    }).cast();
  }

  static Stream<List<GameResultModel>> gameResultModelStream(
      User user, AccountType type) {
    CollectionReference<Map<String, dynamic>> historyRef =
        type == AccountType.rank ? _rankHistory : _unrankHistory;

    return historyRef
        .doc(user.uid)
        .snapshots()
        .map<List<GameResultModel>>((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> histories = documentSnapshot.data()!;
        List<String> allKeys = histories.keys.toList()
          ..sort((a, b) => int.parse(b).compareTo(int.parse(a)));

        return allKeys.map((key) {
          return GameResultModel.fromJson(histories[key]);
        }).toList();
      }
      return [];
    }).cast();
  }

  static Future<void> updateUser(User user, Map<String, dynamic> data) {
    return _user.doc(user.uid).update(data);
  }

  static Future<void> updateAccount(
      User user, Map<String, dynamic> data, AccountType type) {
    CollectionReference<Map<String, dynamic>> accountRef =
        type == AccountType.rank ? _rankAccount : _unrankAccount;
    return accountRef.doc(user.uid).update(data);
  }

  static Future<void> updateGameResult(
      GameResultModel gameResultModel, User user) async {
    CollectionReference<Map<String, dynamic>> historyRef =
        gameResultModel.gameTypeModel.accountType == AccountType.rank
            ? _rankHistory
            : _unrankHistory;
    historyRef.doc(user.uid).set({
      "${gameResultModel.date.millisecondsSinceEpoch}":
          gameResultModel.toJson(),
    }, SetOptions(merge: true));
  }

  static Future<List<RankModel>> getRankList() async {
    DocumentSnapshot<Map<String, dynamic>> lastUpdateInfo =
        await _rank.doc('lastUpdateInfo').get();
    if (!lastUpdateInfo.exists) {
      return [];
    }
    String updatePath = lastUpdateInfo["updatePath"];
    DocumentSnapshot<Map<String, dynamic>> dataAtLastUpdatePath =
        await _rank.doc(updatePath).get();
    if (!dataAtLastUpdatePath.exists) {
      return [];
    }

    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(dataAtLastUpdatePath.data()!["list"]);
    return data.map((item) => RankModel.fromJson(item)).toList();
  }
}
