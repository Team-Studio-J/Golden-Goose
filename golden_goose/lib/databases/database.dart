import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _user = FirebaseFirestore.instance.collection('user');

  static Stream<UserModel> userStream(User user) {
    print("<Database> userStream , uid : ${user.uid}");
    return _user
      .doc(user.uid)
      .snapshots()
      .map((event) {
        if (event.exists) {
          return UserModel.fromDocumentSnapshot(documentSnapshot: event);
        }
        _user.doc(user.uid).set(UserModel(uid: user.uid, email: user.email!, nickname: user.email!.split("@").first).toMap());
        return UserModel();
      })
      .cast();
  }

  static Future<void> userUpdate(User user, Map<String, dynamic> data) {
    return _user
        .doc(user.uid)
        .update(data);
  }
}
