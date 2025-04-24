import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String doctorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Appointments")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorId', isEqualTo: doctorId)
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
                  trailing: appointmentData['status'] == "Pending"
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                FirebaseFirestore.instance.collection('appointments').doc(doc.id).update({'status': 'Confirmed'});
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                FirebaseFirestore.instance.collection('appointments').doc(doc.id).update({'status': 'Rejected'});
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
