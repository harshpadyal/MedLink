import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medlink/utils/dialogs.dart';
import 'package:medlink/models/doctor_model.dart'; // Import Doctor model
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "641097014683-pr9jdi0s76of2nb3suugi6ualiij0lq1.apps.googleusercontent.com",
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up with Email & Password
  Future<User?> signUp(String email, String password, String role) async {
    try {
      print("Attempting to sign up user: $email");

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Send email verification
      await user?.sendEmailVerification();
      print("Verification email sent to: ${user?.email}");

      // Store user details in Firestore
      await _firestore.collection('users').doc(user?.uid).set({
        'email': email,
        'role': role, // Store user role (User or Doctor)
        'createdAt': FieldValue.serverTimestamp(),
      });

      // If the user is a doctor, store doctor details using Doctor model
      if (role == 'Doctor') {
        Doctor newDoctor = Doctor(
          id: user!.uid,
          name: '',
          specialization: '',
          location: '',
          rating: 0.0,
        );

        await _firestore.collection('doctors').doc(user.uid).set(newDoctor.toMap());
      }

      return user;
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

      User? user = userCredential.user;
      if (user?.emailVerified == true) {
        print("Login Successful for: ${user?.email}");

        // Fetch role from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user?.uid).get();
        String role = userDoc['role'] ?? 'User';

        print("User role: $role");
        return user;
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
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user == null) return null;

      // Check if user exists in Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // If new user, ask for role selection
        String? selectedRole = await showRoleSelectionDialog(context);
        
        if (selectedRole != null) {
          // Save user details with selected role
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'role': selectedRole,
            'createdAt': FieldValue.serverTimestamp(),
          });

          // If Doctor, add to the doctors collection using Doctor model
          if (selectedRole == 'Doctor') {
            Doctor newDoctor = Doctor(
              id: user.uid,
              name: user.displayName ?? '',
              specialization: '',
              location: '',
              rating: 0.0,
            );

            await _firestore.collection('doctors').doc(user.uid).set(newDoctor.toMap());
          }
        }
      }

      return user;
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
