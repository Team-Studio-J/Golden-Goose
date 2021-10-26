import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/models/user.dart';


class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _user = FirebaseFirestore.instance.collection('user');

  Stream<UserModel> userStream(String uid) {
    print("userStream , uid : ${uid}");
    return _user
      .doc(uid)
      .snapshots()
      .map((event) {
        if (event.exists) {
          print("exists");
          return UserModel.fromDocumentSnapshot(documentSnapshot: event);
        }
        print("null");
        return UserModel();
      })
      .cast();
  }
}

