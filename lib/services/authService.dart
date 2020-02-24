import 'package:firebase_auth/firebase_auth.dart';
import 'package:koli/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Convert Firebase user to a simple User object
  User _userFromFirebaseUser(FirebaseUser user) {
    if(user != null) {
      return User(uid: user.uid);
    }
  }

  // Change user stream on authentication
  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  // Sign up via Email and Password
  Future signUpWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(error) {
      print(error.toString());
    }
  }

  // Sign in via Email and Password
  Future signInEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(error) {
      print(error.toString());
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(error) {
      print(error.toString());
      return null;
    }
  }

}
