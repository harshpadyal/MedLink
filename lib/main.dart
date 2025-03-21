import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/symptom_checker.dart';
import 'screens/medicine_reminder.dart';
import 'screens/emergency_map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure Firebase options are set
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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/symptom_checker': (context) => SymptomCheckerScreen(),
        '/medicine_reminder': (context) => MedicineReminderScreen(),
        '/emergency_map': (context) => EmergencyMapScreen(),
      },
    );
  }
}
