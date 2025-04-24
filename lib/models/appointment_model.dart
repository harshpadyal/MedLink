import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String id;
  String doctorId;
  String userId;
  String status; // "Pending", "Confirmed", "Completed"
  Timestamp timestamp; // Firestore stores timestamps in UTC

  Appointment({
    required this.id,
    required this.doctorId,
    required this.userId,
    this.status = 'Pending',
    required this.timestamp,
  });

  // Convert Appointment object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'userId': userId,
      'status': status,
      'timestamp': timestamp,
    };
  }

  // Convert Firestore document to Appointment object
  factory Appointment.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return Appointment(
      id: doc.id,
      doctorId: data?['doctorId'] ?? '',
      userId: data?['userId'] ?? '',
      status: data?['status'] ?? 'Pending',
      timestamp: data?['timestamp'] ?? Timestamp.now(),
    );
  }
}
