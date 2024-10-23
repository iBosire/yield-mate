import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:yield_mate/models/user_model.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges()
      .map((User? user) => _userFromFirebaseUser(user));
  }

  // create user object
  UserModel? _userFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(uid: user.uid, iconPath: 'assets/icons/user.svg');
  }


  // Sign in anonymously
  Future<UserModel?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e) {
      log(e.toString());
      return null;
    }
  }

  // register with email and password
  Future<List<dynamic>> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return [_userFromFirebaseUser(user!), null];
    } catch(e) {
      log(e.toString());
      return [null, e];
    }
  }

  // Sign in with email and password

  //  Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      log(e.toString());
      return null;
    }
  }
}