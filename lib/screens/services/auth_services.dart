import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:privatemessaging/models/usermodel.dart';
import 'package:privatemessaging/screens/services/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//Get Users Details

  //Register User with Add User
  Future<String> signUpUser(
      {required String pass,
      required String name,
      required Uint8List file}) async {
    String res = 'Some error occured';
    try {
      if (name.isNotEmpty || pass.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: name + "@example.com", password: pass);
        String photoURL = await StorageMethods()
            .uploadImageToStorage('ProfilePics', file, false);
        //Add User to the database with modal
        UserModel userModel = UserModel(
            uid: cred.user!.uid,
            name: name,
            password: pass,
            photoURL: photoURL);
        await firebaseFirestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(userModel.toJson());
        res = 'sucess';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  ///Login User with Add Useer
  Future<String> loginUpUser({
    required String email,
    required String pass,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty || pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);

        res = 'sucess';
      }
    } on FirebaseException catch (e) {
      if (e == 'WrongEmail') {
        print(e.message);
      }
      if (e == 'WrongPassword') {
        print(e.message);
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
