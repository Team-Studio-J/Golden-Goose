import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const initialMoney = 100000;
  String uid;
  String nickname;
  String email;
  int rankMoney;
  int unrankMoney;

  UserModel({
    this.uid = "not connected",
    this.nickname = "empty",
    this.email = "empty",
    this.rankMoney = initialMoney,
    this.unrankMoney = initialMoney,
  }) {
    _printStatus();
  }

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot})
      : uid = documentSnapshot.id,
        nickname = documentSnapshot["nickname"] ?? "not set",
        email = documentSnapshot["email"],
        rankMoney = documentSnapshot["rankMoney"] ?? initialMoney,
        unrankMoney = documentSnapshot["unrankMoney"] ?? initialMoney {
    _printStatus(caller: "fromDocumentSnapshot");
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "nickname": nickname,
      "rankMoney": rankMoney,
      "unrankMoney": unrankMoney,
    };
  }

  static Map<String, dynamic> mapper(
      {String? uid,
      String? nickname,
      String? email,
      int? rankMoney,
      int? unrankMoney}) {
    Map<String, dynamic> map = {};
    if(uid != null) map["uid"] = uid;
    if(nickname != null) map["nickname"] = nickname;
    if(email != null) map["email"] = email;
    if(rankMoney != null) map["rankMoney"] = rankMoney;
    if(unrankMoney != null) map["unrankMoney"] = unrankMoney;
    return map;
  }

  void _printStatus({String? caller}) {
    print("<UserModel>${caller ?? ""} ${toMap()}");
  }
}
