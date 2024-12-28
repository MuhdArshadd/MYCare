import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';


//Update
class ClinicDetailsPage extends StatefulWidget {
  final User user;
  final String id;
  final String name;
  final String contact;
  final Uint8List imagePath;
  final String address;
  final String operationHours;
  final String serviceDescription;
  final double latitude;
  final double longitude;
  final String distance;
  final String status;

  ClinicDetailsPage({
    required this.user,
    required this.id,
    required this.name,
    required this.contact,
    required this.imagePath,
    required this.address,
    required this.operationHours,
    required this.serviceDescription,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.status,
  });

  @override
  _ClinicDetailsPageState createState() => _ClinicDetailsPageState();
}

class _ClinicDetailsPageState extends State<ClinicDetailsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to open Google Maps
  Future<void> openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude'); // Google Maps URL format

    if (await canLaunch(googleMapsUri.toString())) {
      await launch(googleMapsUri.toString());
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  // Launch phone dialer
  Future<void> _launchDialer(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinic Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                widget.imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // Clinic Name
            Text(
              widget.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Contact Information with clickable link
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.contact_phone, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Call the _launchDialer function with the dynamic number
                      _launchDialer(widget.contact);
                    },
                    child: Text(
                      widget.contact,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline, // Underline for link appearance
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.address,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Operation Hours
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.operationHours,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Service Description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.serviceDescription,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Distance
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_searching, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.distance,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Button to launch Google Maps with Latitude and Longitude
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                openGoogleMaps(widget.latitude, widget.longitude); // Open location in Google Maps
              },
              child: const Text('Open in Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user: widget.user),
    );
  }
}