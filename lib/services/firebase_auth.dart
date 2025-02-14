import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Connect to the firebase emulator only in debug mode
  void connectAuthEmulator() {
    _auth.useAuthEmulator('localhost', 9099);
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    }
    catch (e) {
      print("Sign up error: $e");
      return null;
    }
  }

  Future<User?> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    }
    catch (e) {
      print("Sign up error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}