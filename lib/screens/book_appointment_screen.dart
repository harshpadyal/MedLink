import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;
  BookAppointmentScreen({required this.doctorId});

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime selectedDate = DateTime.now();

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _bookAppointment() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('appointments').add({
      'doctorId': widget.doctorId,
      'userId': userId,
      'date': selectedDate,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Appointment Request Sent")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Select Appointment Date"),
          SizedBox(height: 10),
          Text("${selectedDate.toLocal()}".split(' ')[0]),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text("Choose Date"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _bookAppointment,
            child: Text("Confirm Appointment"),
          ),
        ],
      ),
    );
  }
}
