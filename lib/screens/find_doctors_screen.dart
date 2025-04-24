import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medlink/screens/book_appointment_screen.dart';
import 'package:medlink/screens/nearby_doctors_screen.dart'; // Import NearbyDoctorsScreen

class FindDoctorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find Doctors")),
      body: Column(
        children: [
          // Button to find nearby doctors
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NearbyDoctorsScreen()),
                );
              },
              child: Text("Find Nearby Doctors"),
            ),
          ),
          
          // Doctors list
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('doctors')
                  .where('profileComplete', isEqualTo: true) // Filter only complete profiles
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No doctors available"));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> doctorData = doc.data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(doctorData['name'] ?? "Unknown Doctor"),
                        subtitle: Text(doctorData['specialization'] ?? "No specialization"),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookAppointmentScreen(doctorId: doc.id),
                              ),
                            );
                          },
                          child: Text("Book"),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
