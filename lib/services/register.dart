import 'package:firebase_auth/firebase_auth.dart';

class RegisterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> registerWithEmailAndPassword({
    required String password,
    required String email,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
      }
      print('User registered successfully: ${user!.email}');

      // Sign in the user after successful registration
      UserCredential signInCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User signed in automatically after registration: ${signInCredential.user!.email}');

      return userCredential;
    } catch (error) {
      print('Error while performing email and password registration: $error');
      return null;
    }
  }

}
