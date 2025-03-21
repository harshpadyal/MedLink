import 'package:flutter/material.dart';

class EmergencyMapScreen extends StatelessWidget {
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
          title: Text('Emergency Map'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Column(
          children: [
            // Map placeholder with image
            GestureDetector(
              onDoubleTap: () {
                _showSOSDialog(context);
              },
              child: Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/map_placeholder.png',
                        height: 150,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Emergency Map Feature Coming Soon!',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nearby Emergency Services',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Nearby services list
                    EmergencyServiceTile(
                      name: 'City Hospital',
                      distance: '1.2 km',
                      icon: 'assets/icons/hospital.png',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    EmergencyServiceTile(
                      name: 'Medical Center',
                      distance: '2.5 km',
                      icon: 'assets/icons/clinic.png',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    EmergencyServiceTile(
                      name: 'Downtown Pharmacy',
                      distance: '0.8 km',
                      icon: 'assets/icons/pharmacy.png',
                      color: Color(0xFFFF6B6B),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showSOSDialog(context);
          },
          icon: Icon(Icons.emergency),
          label: Text(
            'SOS',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  void _showSOSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Emergency SOS'),
          content: Text('Do you want to send an SOS alert?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Send'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('SOS Alert Sent!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class EmergencyServiceTile extends StatelessWidget {
  final String name;
  final String distance;
  final String icon;
  final Color color;

  const EmergencyServiceTile({
    required this.name,
    required this.distance,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name is located $distance away.')),
        );
      },
      child: Card(
        elevation: 1,
        margin: EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
              color: color,
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Distance: $distance',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.directions),
            color: color,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Getting directions to $name...')),
              );
            },
          ),
        ),
      ),
    );
  }
}
