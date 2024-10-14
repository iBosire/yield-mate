import 'package:firebase_auth/firebase_auth.dart';
import 'package:yield_mate/models/user_model.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object
  UserModel? _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid, iconPath: 'assets/icons/user.svg') : null;
  }

  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password

}