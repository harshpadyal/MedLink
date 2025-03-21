import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:medlink/utils/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  void resetPassword() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      bool success = await authService.resetPassword(email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? "Password reset link sent! Check your email." : "Failed to send reset email. Try again.")),
      );

      if (success) {
        Navigator.pop(context); // Go back to the login screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Reset Password"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Enter your email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your email";
                    } else if (!EmailValidator.validate(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: resetPassword,
                  child: Text("Send Reset Link"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
