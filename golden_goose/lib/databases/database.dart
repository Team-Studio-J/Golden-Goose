import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/models/rank_model.dart';
import 'package:golden_goose/models/user_model.dart';

class Database {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    print("<Database> userStream , uid : ${user.uid}");
    return _user.doc(user.uid).snapshots().map<UserModel>((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> userJson = documentSnapshot.data()!;
        if (!userJson.containsKey("registrationDate") || !userJson.containsKey("uid")) {
          userJson['uid'] = user.uid;
          userJson['registrationDate'] = Timestamp.now();
          _user.doc(user.uid).set(userJson);
        }
        UserModel userModel =
        UserModel.fromJson(userJson);
        return userModel;
      }

      UserModel defaultUser = UserModel(
        uid: user.uid,
        email: user.email!,
        nickname: user.email!.split("@").first,
        registrationDate: DateTime.now(),
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
    historyRef.doc(user.uid).set(
        {"${DateTime.now().millisecondsSinceEpoch}": gameResultModel.toJson()},
        SetOptions(merge: true));
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
    List<RankModel> list = [];
    for (var item in data) {
      var data = item;
      var user = Map<String, dynamic>.from(data['user']);
      user.putIfAbsent("uid", () => data['uid']);
      data.update("user", (value) => user);
      list.add(RankModel.fromJson(data));
    }
    return list;
  }

  static Future<List<GameResultModel>> getGameHistoryList(
      User user, AccountType type) async {
    CollectionReference<Map<String, dynamic>> historyRef =
        type == AccountType.rank ? _rankHistory : _unrankHistory;

    DocumentSnapshot<Map<String, dynamic>> historiesSnapshot =
        await historyRef.doc(user.uid).get();
    if (!historiesSnapshot.exists) {
      return [];
    }

    Map<String, dynamic> histories = historiesSnapshot.data()!;
    List<String> allKeys = histories.keys.toList()
      ..sort((a, b) => int.parse(b).compareTo(int.parse(a)));

    return allKeys.map((key) {
      var data = Map<String, dynamic>.from(histories[key]);
      data.putIfAbsent("date", () => Timestamp.fromMillisecondsSinceEpoch(int.parse(key)));
      return GameResultModel.fromJson(data);
    }).toList();
  }
}
