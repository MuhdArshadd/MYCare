import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../controller/foodbankController.dart';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chatbotAI.dart';
import 'foodbankPage.dart';

class FoodbankDetailPage extends StatefulWidget {
  final User user;
  final String foodbankID;
  final LatLng? currentLocation;

  const FoodbankDetailPage({
    super.key,
    required this.foodbankID,
    required this.currentLocation,
    required this.user,
  });

  @override
  State<FoodbankDetailPage> createState() => _FoodbankDetailPageState();
}

class _FoodbankDetailPageState extends State<FoodbankDetailPage> {
  LatLng? currentLocation;
  final Location _locationController = Location();
  bool isLoading = true;

  final FoodBank foodbankController = FoodBank();
  late Future<Map<String, dynamic>> foodbankDetails;

  Future<void> _loadFoodbankDetails() async {
    final details = await foodbankController.fetchFoodbankDetails(widget.foodbankID);
    setState(() {
      foodbankDetails = Future.value(details);
    });
  }

  Future<void> openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
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
  void initState() {
    super.initState();
    _loadFoodbankDetails().then((_) {
      setState(() {
        isLoading = false;
      });
    });
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
        future: foodbankDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found.'));
          } else {
            final foodbankData = snapshot.data!;
            final double latitude = foodbankData['latitude'];
            final double longitude = foodbankData['longitude'];

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section with Back Button and Text in Black
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            // Navigate to FoodbankPage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => FoodbankPage(user: widget.user)),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Foodbank Details',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black, // Text color changed to black
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: foodbankData['image_url'] != null
                        ? Image.network(
                      foodbankData['image_url'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 200,
                          color: Colors.grey,
                        );
                      },
                    )
                        : const Icon(
                      Icons.broken_image,
                      size: 200,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Content Section with Black Text and Icons
                  _buildSection(
                    context,
                    title: 'Foodbank Location Name',
                    content: foodbankData['foodbankname'],
                    icon: Icons.location_on, // Location icon
                  ),
                  _buildSection(
                    context,
                    title: 'Address',
                    content: foodbankData['address'],
                    icon: Icons.map, // Map icon
                  ),
                  _buildSection(
                    context,
                    title: 'Type of Food Donated',
                    content: foodbankData['typeoffood'],
                    icon: Icons.fastfood, // Fast food icon
                  ),
                  _buildSection(
                    context,
                    title: 'Foodbank Status',
                    content: foodbankData['foodbankstatus'],
                    icon: Icons.storefront, // Storefront icon for status
                  ),
                  const SizedBox(height: 16),

                  // Google Maps Button
                  ElevatedButton(
                    onPressed: () {
                      openGoogleMaps(latitude, longitude);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: const Text(
                      'Open in Google Maps',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
        },
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

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required String content,
        IconData? icon,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 28, color: Colors.blueAccent),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black, // Text color changed to black
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Text color changed to black
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
