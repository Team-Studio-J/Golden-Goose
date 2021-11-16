import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  static const initialBalance = 100000;
  int balance;
  int gameCount;
  int longWhenRise;
  int holdWhenRise;
  int shortWhenRise;
  int longWhenFall;
  int holdWhenFall;
  int shortWhenFall;

  int get longs => longWhenRise + longWhenFall;

  int get holds => holdWhenRise + holdWhenFall;

  int get shorts => shortWhenRise + shortWhenFall;

  int get correctCount => longWhenRise + shortWhenFall;

  int get incorrectCount => longWhenFall + shortWhenRise;

  double get winRate => correctCount / (incorrectCount + correctCount);

  double get holdRate => holds / (longs + holds + shorts);

  double get bettingRate => longs + shorts / (longs + holds + shorts);

  Account({
    this.balance = Account.initialBalance,
    this.gameCount = 0,
    this.longWhenRise = 0,
    this.holdWhenRise = 0,
    this.shortWhenRise = 0,
    this.longWhenFall = 0,
    this.holdWhenFall = 0,
    this.shortWhenFall = 0,
  });

  factory Account.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      Account.fromJson(documentSnapshot.data()!);

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  static Map<String, dynamic> nullSafeMapper({
    int? balance,
    int? gameCount,
    int? longWhenRise,
    int? holdWhenRise,
    int? shortWhenRise,
    int? longWhenFall,
    int? holdWhenFall,
    int? shortWhenFall,
  }) {
    Map<String, dynamic> map = {};
    if (balance != null) map["balance"] = balance;
    if (gameCount != null) map["gameCount"] = gameCount;
    if (longWhenRise != null) map["longWhenRise"] = longWhenRise;
    if (holdWhenRise != null) map["holdWhenRise"] = holdWhenRise;
    if (shortWhenRise != null) map["shortWhenRise"] = shortWhenRise;
    if (longWhenFall != null) map["longWhenFall"] = longWhenFall;
    if (holdWhenFall != null) map["holdWhenFall"] = holdWhenFall;
    if (shortWhenFall != null) map["shortWhenFall"] = shortWhenFall;
    return map;
  }

}
