import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'chatbotAI.dart';
import 'foodbankPage.dart';
import 'categoryMedicalService.dart';
import 'categorySkillBuilding.dart';
import 'package:location/location.dart';

class SupportServicePage extends StatefulWidget {
  final User user;
  const SupportServicePage({super.key, required this.user});

  @override
  State<SupportServicePage> createState() => _SupportServicePageState();
}

class _SupportServicePageState extends State<SupportServicePage> {
  LatLng? currentLocation;
  final Location _locationController = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    try {
      final locationData = await _locationController.getLocation();
      setState(() {
        currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support service',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SupportServiceCard(
                  image: 'assets/foodbank.png',
                  label: 'Foodbank',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodbankPage(
                          currentLocation: currentLocation,
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                ),
                SupportServiceCard(
                  image: 'assets/medical.png',
                  label: 'Medical service',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryMedicalService(user: widget.user, currentLocation: currentLocation),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: SupportServiceCard(
                image: 'assets/skill.png',
                label: 'Skill Building Programme',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorySkillBuilding(user: widget.user),
                    ),
                  );
                },
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
}

class SupportServiceCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const SupportServiceCard({
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120, // Fixed width for consistency
              height: 120, // Fixed height for consistency
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
