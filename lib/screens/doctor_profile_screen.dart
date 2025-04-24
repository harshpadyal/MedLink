import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  String doctorId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  void _fetchDoctorData() async {
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    if (doctorDoc.exists) {
      setState(() {
        nameController.text = doctorDoc['name'] ?? "";
        specializationController.text = doctorDoc['specialization'] ?? "";
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('doctors').doc(doctorId).update({
        'name': nameController.text,
        'specialization': specializationController.text,
        'profileComplete': true, // Marks the doctor as available for booking
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile Updated Successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctor Profile & Settings")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: specializationController,
                decoration: InputDecoration(labelText: "Specialization"),
                validator: (value) => value!.isEmpty ? "Enter specialization" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text("Save Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
