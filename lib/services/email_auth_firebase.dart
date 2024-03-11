import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthFirebase {
  final auth = FirebaseAuth.instance;

  Future<bool> signUpUser(
      {required String name,
      required String password,
      required String email}) async {
    try {
      final UserCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (UserCredential.user != null) {
        UserCredential.user!.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInUser(
      {required String password, required String email}) async {
    var band = false;
    final UserCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (UserCredential.user != null) {
      if (UserCredential.user!.emailVerified) {
        band = true;
      }
    }
    return band;
  }
}
