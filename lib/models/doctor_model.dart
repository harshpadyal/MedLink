import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  String id;
  String name;
  String specialization;
  String location;
  double rating;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.location,
    this.rating = 0.0, // Default rating is 0.0
  });

  // Convert Doctor object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'location': location,
      'rating': rating,
    };
  }

  // Convert Firestore document to Doctor object
  factory Doctor.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return Doctor(
      id: doc.id,
      name: data?['name'] ?? '',
      specialization: data?['specialization'] ?? '',
      location: data?['location'] ?? '',
      rating: (data?['rating'] ?? 0.0).toDouble(),
    );
  }
}
