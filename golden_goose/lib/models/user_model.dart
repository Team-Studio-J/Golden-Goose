import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String nickname;
  String email;

  UserModel({
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
}
