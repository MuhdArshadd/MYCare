import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/newsController.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'foodbankPage.dart';
import 'medicalService.dart';
import 'skillBuildingPage.dart';
import 'package:location/location.dart';

class SupportServicePage extends StatefulWidget {
  final String noIc;
  const SupportServicePage({super.key, required this.noIc});

  @override
  State<SupportServicePage> createState() => _SupportServicePageState();
}

class _SupportServicePageState extends State<SupportServicePage> {
  List<Map<String, dynamic>> _supportServices = [];
  bool _isLoading = true;
  LatLng? currentLocation;
  final Location _locationController = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchSupportServices();
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
        currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }


  Future<void> _fetchSupportServices() async {
    try {
      News news = News();
      var services = await news.fetchSupportService();
      setState(() {
        _supportServices = services;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching support services: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
                    Navigator.push(
                      context,
                        MaterialPageRoute(builder: (context) => FoodbankPage(currentLocation: currentLocation)),
                    );
                  },
                ),
                SupportServiceCard(
                  image: 'assets/medical.png',
                  label: 'Medical service',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicalService(currentLocation: currentLocation)),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SkillBuildingPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
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
              width: 120, // Set a fixed width for all images to ensure consistent size
              height: 120, // Set a fixed height for all images
              child: Image.asset(
                image,
                fit: BoxFit.cover, // Ensure the image covers the entire container
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


