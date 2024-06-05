import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String password;
  String photoURL;
  String name;

  UserModel(
      {required this.uid,
      required this.name,
      required this.photoURL,
      required this.password});

  ///Converting OBject into Json Object
  Map<String, dynamic> toJson() =>
      {'password': password, 'uid': uid, "name": name, 'photoURL': photoURL};

  ///
  static UserModel fromSnap(DocumentSnapshot snaps) {
    var snapshot = snaps.data() as Map<String, dynamic>;

    return UserModel(
      password: snapshot['password'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      photoURL: snapshot['photoURL'],
    );
  }
}
