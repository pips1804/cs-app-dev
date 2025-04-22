import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return "Email or password is incorrect.";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String? get currentUserEmail => _auth.currentUser?.email;
}
