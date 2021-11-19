import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/utils/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

//flutter pub run build_runner build
@JsonSerializable()
@TimestampConverter()
class UserModel {
  String uid;
  String nickname;
  String email;
  int? rank;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? rankUpdateDate;
  int? unitTimeBeforeRank;

  UserModel({
    this.uid = "empty",
    this.nickname = "empty",
    this.email = "empty",
  });

  factory UserModel.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      UserModel.fromJson(documentSnapshot.data()!);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static Map<String, dynamic> nullSafeMapper(
      {String? nickname, String? email}) {
    Map<String, dynamic> map = {};
    if (nickname != null) map["nickname"] = nickname;
    if (email != null) map["email"] = email;
    return map;
  }

  static DateTime? _dateTimeFromTimestamp(Timestamp? timestamp) => timestamp?.toDate();

  static Timestamp? _dateTimeToTimestamp(DateTime? date) => date == null ? null : Timestamp.fromDate(date);

  String get formattedRank => _formattedRank(rank);

  static String _formattedRank(int? rank){
    if(rank == null) {
      return "-";
    }
    if(rank <= 0) {
      return "-";
    }
    if(rank == 1) {
      return "1 st";
    }
    if(rank == 2) {
      return "2 nd";
    }
    if(rank == 3) {
      return "3 rd";
    }
    return "$rank th";
  }
}
