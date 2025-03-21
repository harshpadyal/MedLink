import 'package:flutter/material.dart';

class MedicineReminderScreen extends StatelessWidget {
  final List<Map<String, dynamic>> medications = [
    {
      'name': 'Paracetamol',
      'dosage': '500mg',
      'time': '08:00 AM',
      'icon': 'assets/icons/pill.png',
    },
    {
      'name': 'Vitamin C',
      'dosage': '1000mg',
      'time': '09:00 AM',
      'icon': 'assets/icons/vitamin.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context); // Swipe right to go back
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Medicine Reminder'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Column(
          children: [
            // Header with illustration
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Double-tap to view full medication schedule!')),
                      );
                    },
                    child: Image.asset(
                      'assets/images/medicine_illustration.png',
                      height: 120,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Never Miss Your Medication',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Medicine list header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    'Today\'s Schedule',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  TextButton.icon(
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('Add New'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Feature to add new medicine coming soon!')),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Medicine list
            Expanded(
              child: medications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty_list.png',
                            height: 100,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No medications scheduled',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: medications.length,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final medication = medications[index];
                        return GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${medication['name']} reminder activated!')),
                            );
                          },
                          onLongPress: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${medication['name']} is scheduled for ${medication['time']}.')),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.asset(
                                  medication['icon'],
                                  width: 28,
                                  height: 28,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                medication['name'],
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    'Dosage: ${medication['dosage']}',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Time: ${medication['time']}',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.notifications_active),
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Reminder for ${medication['name']} set!')),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Adding new medications will be available soon!')),
            );
          },
        ),
      ),
    );
  }
}
