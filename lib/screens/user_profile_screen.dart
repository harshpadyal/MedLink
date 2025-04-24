import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  String userEmail = FirebaseAuth.instance.currentUser!.email ?? "No Email";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        nameController.text = userDoc['name'] ?? ""; // Load name if it exists
      });
    }
  }

  void _saveProfile() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': nameController.text, // Save user name
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated Successfully")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Email: $userEmail", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveProfile, child: Text("Save Profile")),
            ],
          ),
        ),
      ),
    );
  }
}
