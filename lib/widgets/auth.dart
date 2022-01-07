import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential?> login(
      {required String email, required String password}) async {
    UserCredential userCredential;
    userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    // auth.signInAnonymously()

    return userCredential;
  }

  Future<UserCredential?> signup(
      {required String email,
      required String password,
      required String username}) async {
    UserCredential userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      return null;
    }

    if (userCredential.user != null) {
      userCredential.user!.updateDisplayName(username);
      userCredential.user!.reload();
      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({"username": username, "email": email, "time": DateTime.now()});
    }

    return userCredential;
  }
}
