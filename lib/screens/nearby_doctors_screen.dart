import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medlink/screens/book_appointment_screen.dart';

class NearbyDoctorsScreen extends StatefulWidget {
  @override
  _NearbyDoctorsScreenState createState() => _NearbyDoctorsScreenState();
}

class _NearbyDoctorsScreenState extends State<NearbyDoctorsScreen> {
  GoogleMapController? mapController;
  Position? userLocation;
  Map<String, LatLng> doctorLocations = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchAvailableDoctors();
  }

  // Fetch user's live location
  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLocation = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Fetch only available doctors with a complete profile
  Future<void> _fetchAvailableDoctors() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          // .where('profileComplete', isEqualTo: true) // Only show doctors with complete profiles
          // .where('available', isEqualTo: true) // Only show available doctors
          .get();

      Map<String, LatLng> locations = {};
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        print("Fetched doctor: ${data}"); // Debugging output

        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          locations[doc.id] = LatLng(data['latitude'], data['longitude']);
        } else {
          print("Doctor ${doc.id} missing location data");
        }
      }

      setState(() {
        doctorLocations = locations;
      });

      print("Final doctor locations: $doctorLocations"); // Debugging output
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Doctors")),
      body: userLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal, // Ensures a valid map type
              initialCameraPosition: CameraPosition(
                target: LatLng(userLocation!.latitude, userLocation!.longitude),
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
              markers: {
                // User's current location marker
                Marker(
                  markerId: MarkerId("user"),
                  position: LatLng(userLocation!.latitude, userLocation!.longitude),
                  infoWindow: InfoWindow(title: "You are here"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
                // Display available doctors as markers
                ...doctorLocations.entries.map((entry) {
                  return Marker(
                    markerId: MarkerId(entry.key),
                    position: entry.value,
                    infoWindow: InfoWindow(
                      title: "Doctor Available",
                      snippet: "Tap to book an appointment",
                      onTap: () {
                        print("Doctor selected: ${entry.key}"); // Debugging log
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookAppointmentScreen(doctorId: entry.key),
                          ),
                        );
                      },
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  );
                }).toSet(),
              },
            ),
    );
  }
}
