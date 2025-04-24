import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("My Appointments")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Appointments"));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> appointmentData = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text("Appointment on ${appointmentData['date'].toDate()}"),
                  subtitle: Text("Status: ${appointmentData['status']}"),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
