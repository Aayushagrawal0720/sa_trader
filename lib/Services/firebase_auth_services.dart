import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

@immutable
class FUser {
  const FUser({@required this.uid});

  final String uid;
}

class FirebaseAuthService with ChangeNotifier {

  final _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  FUser _userFromFirebase(User user) {
    return user == null ? null : FUser(uid: user.uid);
  }

  Stream<FUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
