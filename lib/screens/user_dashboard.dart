import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medlink/screens/find_doctors_screen.dart';
import 'package:medlink/screens/my_appointments_screen.dart';
import 'package:medlink/screens/user_profile_screen.dart';
import 'package:medlink/screens/login_screen.dart';

class UserDashboard extends StatefulWidget {
  final String userId;
  UserDashboard({required this.userId});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0; // Track selected screen
  String userName = "Enter Your Name"; // Default name if missing
  String userEmail = "Loading...";
  String profilePicUrl = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch User Data from Firestore
  void _fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    print("User ID received: ${widget.userId} | Auth UID: $userId");

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?; // Convert to Map

        setState(() {
          userEmail = userData?['email'] ?? "No Email"; // Always fetch email
          userName = userData?.containsKey('name') == true 
              ? userData!['name'] // Fetch name if it exists
              : "Enter Your Name"; // Default text if missing
          profilePicUrl = userData?['profilePic'] ?? "";
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
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

  // Pages for Navigation
  final List<Widget> _pages = [
    FindDoctorsScreen(),
    MyAppointmentsScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Dashboard"),
        backgroundColor: Colors.blueAccent, 
      ),
      drawer: Drawer(
        child: Column(
          children: [
            isLoading
                ? CircularProgressIndicator() // Show loading indicator
                : UserAccountsDrawerHeader(
                    accountName: Text(userName), // Shows default if missing
                    accountEmail: Text(userEmail), // Always fetched
                    currentAccountPicture: profilePicUrl.isNotEmpty
                        ? CircleAvatar(backgroundImage: NetworkImage(profilePicUrl))
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
                          ),
                  ),
            ListTile(
              leading: Icon(Icons.search, color: Colors.blueAccent),
              title: Text("Find Doctors"),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.blueAccent),
              title: Text("Appointments"),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blueAccent),
              title: Text("Settings"),
              onTap: () => _onItemTapped(2),
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
