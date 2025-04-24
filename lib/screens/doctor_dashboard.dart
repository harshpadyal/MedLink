import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medlink/screens/appointments_screen.dart';
import 'package:medlink/screens/doctor_profile_screen.dart';
import 'package:medlink/screens/login_screen.dart';

class DoctorDashboard extends StatefulWidget {
  final String doctorId;
  DoctorDashboard({required this.doctorId});

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedIndex = 0; // Track selected screen
  String doctorName = "Doctor";
  String doctorEmail = "doctor@example.com";
  String profilePicUrl = ""; 
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
    _updateDoctorLocation(); // Auto-update location on login
  }

  // Fetch Doctor Data from Firestore
  void _fetchDoctorData() async {
    String authUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.doctorId)
          .get();

      if (doctorDoc.exists) {
        setState(() {
          doctorName = doctorDoc['name'] ?? "Doctor";
        });
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUserId)
          .get();

      if (userDoc.exists) {
        setState(() {
          doctorEmail = userDoc['email'] ?? "doctor@example.com";
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching doctor data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // **Auto-Update Doctor's Live Location**
  Future<void> _updateDoctorLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await FirebaseFirestore.instance.collection('doctors').doc(widget.doctorId).update({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      print("Doctor location updated: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Error updating location: $e");
    }
  }

  // Logout function
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Navigation Handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  final List<Widget> _pages = [
    AppointmentsScreen(),
    DoctorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctor Dashboard")),
      drawer: Drawer(
        child: Column(
          children: [
            isLoading
                ? CircularProgressIndicator()
                : UserAccountsDrawerHeader(
                    accountName: Text(doctorName),
                    accountEmail: Text(doctorEmail),
                    currentAccountPicture: profilePicUrl.isNotEmpty
                        ? CircleAvatar(backgroundImage: NetworkImage(profilePicUrl))
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
                          ),
                  ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.blueAccent),
              title: Text("Appointments"),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blueAccent),
              title: Text("Settings"),
              onTap: () => _onItemTapped(1),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
