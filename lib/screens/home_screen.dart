import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medlink/utils/auth_service.dart';
import 'package:medlink/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  void _logout(BuildContext context) async {
    await authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          FontAwesomeIcons.stethoscope,
          color: Colors.white,
        ),
        title: Text(
          'MedLink',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              FeatureTile(
                title: 'Symptom Checker',
                icon: FontAwesomeIcons.diagnoses,
                color: Theme.of(context).colorScheme.primary,
                route: '/symptom_checker',
              ),
              FeatureTile(
                title: 'Medicine Reminder',
                icon: FontAwesomeIcons.pills,
                color: Theme.of(context).colorScheme.secondary,
                route: '/medicine_reminder',
              ),
              FeatureTile(
                title: 'Emergency Map',
                icon: FontAwesomeIcons.mapMarkedAlt,
                color: Color(0xFFFF6B6B),
                route: '/emergency_map',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  const FeatureTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
