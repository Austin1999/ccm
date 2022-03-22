import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Stream<bool> checkUserVerified() async* {
    bool verified = false;
    while (!verified) {
      await Future.delayed(Duration(seconds: 5));
      if (currentUser != null) {
        await currentUser!.reload();
        verified = currentUser!.emailVerified;
        if (verified) yield true;
      }
    }
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<String> resetPassword({required String email}) async {
    return _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((value) => "Success")
        .catchError((error) {
      return error.code.toString();
    });
  }

  @override
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
