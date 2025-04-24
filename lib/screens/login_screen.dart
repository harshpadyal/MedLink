import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:medlink/utils/auth_service.dart';
import 'package:medlink/screens/signup_screen.dart';
import 'package:medlink/screens/reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  // 🔹 Normal Email/Password Login
  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      var user = await authService.signIn(email, password);
      if (user != null) {
        // Fetch user role from Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        String role = userDoc['role'] ?? 'User';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );

        // Redirect based on role
        if (role == 'Doctor') {
          Navigator.pushReplacementNamed(context, '/doctor_dashboard',
              arguments: user.uid);
        } else {
          Navigator.pushReplacementNamed(context, '/user_dashboard',
              arguments: user.uid);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed. Check credentials.')),
        );
      }
    }
  }

  // 🔹 Google Sign-In with Role Selection
  void _googleLogin() async {
    var user = await authService.signInWithGoogle(context);
    if (user != null) {
      // Fetch user role from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      String role = userDoc['role'] ?? 'User';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Successful!')),
      );

      // Redirect based on role
      if (role == 'Doctor') {
        Navigator.pushReplacementNamed(context, '/doctor_dashboard',
            arguments: user.uid);
      } else {
        Navigator.pushReplacementNamed(context, '/user_dashboard',
            arguments: user.uid);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MedLink Login',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 20),

                // 🔹 Email Input Field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // 🔹 Password Input Field
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // 🔹 Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset_password');
                    },
                    child: Text('Forgot Password?'),
                  ),
                ),
                SizedBox(height: 20),

                // 🔹 Login Button
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                SizedBox(height: 10),

                // 🔹 Google Sign-In Button
                ElevatedButton(
                  onPressed: _googleLogin,
                  child: Text('Sign in with Google'),
                ),
                SizedBox(height: 10),

                // 🔹 Signup Redirect
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Don\'t have an account? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
