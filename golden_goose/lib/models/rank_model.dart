import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/models/user_model.dart';
import 'package:golden_goose/utils/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'account.dart';

part 'rank_model.g.dart';

//flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
@TimestampConverter()
class RankModel {
  @JsonKey(required: true)
  int balance;
  @JsonKey(required: true)
  int rank;
  @JsonKey(required: true)
  Account rankAccount;
  @JsonKey(required: true)
  String uid;
  @JsonKey(required: true)
  UserModel user;

  String get formattedRank => _formattedRank(rank);

  RankModel(
      {required this.balance,
      required this.rank,
      required this.uid,
      required this.rankAccount,
      required this.user});

  /*
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? rankUpdateDate;
  int? unitTimeBeforeRank;
   */
  factory RankModel.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      RankModel.fromJson(documentSnapshot.data()!);

  factory RankModel.fromJson(Map<String, dynamic> json) =>
      _$RankModelFromJson(json);

  Map<String, dynamic> toJson() => _$RankModelToJson(this);

  static Map<String, dynamic> nullSafeMapper(
      {String? nickname, String? email}) {
    Map<String, dynamic> map = {};
    if (nickname != null) map["nickname"] = nickname;
    if (email != null) map["email"] = email;
    return map;
  }

  static String _formattedRank(int rank) {
    if (rank == null) {
      return "-";
    }
    if (rank <= 0) {
      return "-";
    }
    if (rank == 1) {
      return "1 st";
    }
    if (rank == 2) {
      return "2 nd";
    }
    if (rank == 3) {
      return "3 rd";
    }
    return "$rank th";
  }
}
