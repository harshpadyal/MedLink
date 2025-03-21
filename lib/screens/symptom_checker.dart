import 'package:flutter/material.dart';

class SymptomCheckerScreen extends StatefulWidget {
  @override
  _SymptomCheckerScreenState createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final List<String> commonSymptoms = [
    'Headache', 
    'Fever', 
    'Cough', 
    'Sore Throat',
    'Fatigue', 
    'Shortness of Breath', 
    'Nausea'
  ];
  
  final List<bool> selectedSymptoms = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white, // Ensure it's visible
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          title: Text(
            'Symptom Checker',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFF007BFF),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with image
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          _showHint(context);
                        },
                        child: Container(
                          height: 180,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/symptom_checker.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'How are you feeling today?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF007BFF),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Select your symptoms below',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Symptoms list
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Text(
                    'Common Symptoms',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: commonSymptoms.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Symptom: ${commonSymptoms[index]}'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: CheckboxListTile(
                          title: Text(
                            commonSymptoms[index],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: selectedSymptoms[index],
                          activeColor: Color(0xFF007BFF),
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setState(() {
                              selectedSymptoms[index] = value ?? false;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                
                SizedBox(height: 36),
                
                // Check button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showResultDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      'Check Symptoms',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.health_and_safety,
                color: Color(0xFF007BFF),
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Analysis Result',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF007BFF),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Based on your symptoms, you may have:',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.medical_services, color: Color(0xFF007BFF)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Common Cold',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please consult with a healthcare professional for proper diagnosis.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF007BFF),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showHint(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Double-tap on the image for a health tip!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF007BFF),
      ),
    );
  }
}