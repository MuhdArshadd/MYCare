import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../model/userModel.dart';
import 'bottomNavigationBar.dart';
import 'chatbotAI.dart';
import 'appBar.dart';
import 'medicalService.dart';

class ClinicDetailsPage extends StatefulWidget {
  final User user;
  final String id;
  final String name;
  final String contact;
  final String imagePath;
  final String address;
  final String operationHours;
  final String serviceDescription;
  final double latitude;
  final double longitude;
  final String distance;
  final String status;
  final LatLng? currentLocation;

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
    this.currentLocation,
  });

  @override
  _ClinicDetailsPageState createState() => _ClinicDetailsPageState();
}

class _ClinicDetailsPageState extends State<ClinicDetailsPage> {
  Future<void> openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUri =
    Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');

    if (await canLaunch(googleMapsUri.toString())) {
      await launch(googleMapsUri.toString());
    } else {
      throw 'Could not launch Google Maps';
    }
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // Back button styled like in CourseDetails
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: const [
                  SizedBox(width: 12), // Padding to the left of the button
                  Icon(Icons.arrow_back, size: 24),
                  SizedBox(width: 5),
                ],
              ),
            ),
            // Top banner with clinic image
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade400],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Image.network(
                widget.imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Clinic name display
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Clinic Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoCard(
                    icon: Icons.contact_phone,
                    title: 'Contact',
                    content: InkWell(
                      onTap: () {
                        _launchDialer(widget.contact);
                      },
                      child: Text(
                        widget.contact,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildInfoCard(
                    icon: Icons.location_on,
                    title: 'Address',
                    content: Text(widget.address),
                  ),
                  const SizedBox(height: 16),
                  buildInfoCard(
                    icon: Icons.access_time,
                    title: 'Operation Hours',
                    content: Text(widget.operationHours),
                  ),
                  const SizedBox(height: 16),
                  buildInfoCard(
                    icon: Icons.description,
                    title: 'Service Description',
                    content: Text(widget.serviceDescription),
                  ),
                  const SizedBox(height: 16),
                  buildInfoCard(
                    icon: Icons.location_searching,
                    title: 'Distance',
                    content: Text(widget.distance),
                  ),
                  const SizedBox(height: 24),
                  // Open Google Maps Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        openGoogleMaps(widget.latitude, widget.longitude);
                      },
                      child: const Text('Open in Google Maps'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button background
                        foregroundColor: Colors.white, // Button text color
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Image.asset('assets/icon_chatbot.png'),
        tooltip: 'Open Chatbot',
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user: widget.user),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
