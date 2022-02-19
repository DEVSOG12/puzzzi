import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<dynamic> login(
      {required String email, required String password}) async {
    UserCredential userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      return e;
    }

    // auth.signInAnonymously()

    return userCredential;
  }

  Future<bool?> isuseravailable({String? username}) async {
    QuerySnapshot snapshot = await firebaseFirestore.collection("users").get();
    bool isa;
    List p = snapshot.docs.where((element) {
      return (element.data() as Map)["username"] == username;
    }).toList();
    if (p.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> signup(
      {required String email,
      required String password,
      required String username}) async {
    UserCredential userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      return e;
    }

    if (userCredential.user != null) {
      userCredential.user!.updateDisplayName(username);
      userCredential.user!.reload();
      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "username": username,
        "email": email,
        "time": DateTime.now(),
        "level": 1,
        "xp": 70,
        "max_xp": 250
      });
    }

    return userCredential;
  }
}
