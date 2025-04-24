import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medlink/screens/login_screen.dart';
import 'package:medlink/screens/signup_screen.dart';
import 'package:medlink/screens/doctor_dashboard.dart';
import 'package:medlink/screens/user_dashboard.dart';
import 'firebase_options.dart';
import 'package:medlink/screens/reset_password_screen.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MedLinkApp());
}

class MedLinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedLink',
      theme: ThemeData(
        primaryColor: Color(0xFF007BFF),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF007BFF),
          secondary: Color(0xFF20C997),
          background: Color(0xFFF5F5F5),
          surface: Colors.white,
        ),
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/doctor_dashboard') {
          final String doctorId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DoctorDashboard(doctorId: doctorId),
          );
        } else if (settings.name == '/user_dashboard') {
          final String userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => UserDashboard(userId: userId),
          );
        }
        return null;
      },
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/reset_password': (context) => ResetPasswordPage(),
      },
    );
  }
}
