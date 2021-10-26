 import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id = "not connected";
  String nickname = "empty";
  String email = "empty";
  int money = 0;

  UserModel({
    this.id = "not connected",
    this.nickname = "empty",
    this.email = "empty",
    this.money = 0,
  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    nickname = documentSnapshot["name"];
    email = documentSnapshot["email"];
    money = documentSnapshot["money"];
  }
}
