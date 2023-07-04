import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _authEntry = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow.
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request.
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google account.
      UserCredential result = await _authEntry.signInWithCredential(credential);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _authEntry.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        print('User signed in: ${user.email}');
        return user;
      } else {
        print('User sign-in failed (not because of wrong credentials)');
        return null;
      }
    } catch (e) {
      String errorMessage = 'An error occurred while signing in.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'User not found.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address.';
            break;
          default:
            errorMessage = 'Authentication failed. ${e.message}';
            break;
        }
      }
      print(errorMessage);
      return null;
    }
  }


}