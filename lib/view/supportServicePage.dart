import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';
import '../controller/newsController.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';
import 'foodbankPage.dart';
import 'skillBuildingPage.dart';
import 'medicalService.dart';
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

  // Request location permission and get the current location
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.arrow_back, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Support Service',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _supportServices.isNotEmpty
                  ? Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _supportServices.map((service) {
                  return ServiceCard(
                    title: service['name'],
                    imageBytes: service['images'],
                    currentLocation: currentLocation, // Pass location here
                  );
                }).toList(),
              )
                  : const Center(child: Text("No support services available.")),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final Uint8List imageBytes;
  final LatLng? currentLocation;

  const ServiceCard({
    required this.title,
    required this.imageBytes,
    required this.currentLocation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (currentLocation == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fetching location, please wait...'),
            ),
          );
          return;
        }else{
          if (title == 'Foodbank') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodbankPage(currentLocation: currentLocation),
              ),
            );
          } else if (title == 'Medical Service') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MedicalService(currentLocation: currentLocation)),
            );
          } else if (title == 'Skill Building Programme') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SkillBuildingPage()),
            );
          } else {
            print('$title tapped');
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                imageBytes,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

