import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "641097014683-pr9jdi0s76of2nb3suugi6ualiij0lq1.apps.googleusercontent.com",
  );

  // Sign Up with Email & Password
  Future<User?> signUp(String email, String password) async {
    try {
      print("Attempting to sign up user: $email");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();
      print("Verification email sent to: ${userCredential.user?.email}");

      return userCredential.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // Login with Email & Password
  Future<User?> signIn(String email, String password) async {
    try {
      print("Attempting to sign in user: $email");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user?.emailVerified == true) {
        print("Login Successful for: ${userCredential.user?.email}");
        return userCredential.user;
      } else {
        print("Login failed: Email not verified");
        await _auth.signOut();
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Sign Out (Google & Email)
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true; // Email sent successfully
    } catch (e) {
      print("Password Reset Error: $e");
      return false; // Failed to send email
    }
  }
}