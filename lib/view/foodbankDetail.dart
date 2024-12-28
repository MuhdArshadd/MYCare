import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/foodbankController.dart';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'package:url_launcher/url_launcher.dart';

//Foodbank Page detail
class FoodbankDetailPage extends StatefulWidget {
  final User user;
  final String foodbankID;
  final LatLng? currentLocation;

  const FoodbankDetailPage({super.key, required this.foodbankID, required this.currentLocation, required this.user});

  @override
  State<FoodbankDetailPage> createState() => _FoodbankDetailPageState();
}

class _FoodbankDetailPageState extends State<FoodbankDetailPage> {
  // Loading state for page
  bool isLoading = true;

  // Fetch specific data
  final FoodBank foodbankController = FoodBank();
  late Future<Map<String, dynamic>> foodbankDetails;

  // Function to load foodbank details
  Future<void> _loadFoodbankDetails() async {
    final details = await foodbankController.fetchFoodbankDetails(widget.foodbankID);
    setState(() {
      foodbankDetails = Future.value(details);
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
  void initState() {
    super.initState();
    _loadFoodbankDetails().then((_) {
      setState(() {
        isLoading = false; // Stop loading once data is fetched
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Display loading animation
          : FutureBuilder<Map<String, dynamic>>(
        future: foodbankDetails,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Error state
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // No data found state
          else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found.'));
          }
          // Success state - data is available
          else {
            final foodbankData = snapshot.data!;
            final double latitude = foodbankData['latitude'];  // Retrieve latitude
            final double longitude = foodbankData['longitude']; // Retrieve longitude

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Foodbank',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: foodbankData['imagePlace'] != null
                          ? Image.memory(
                        foodbankData['imagePlace'],
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
                    _buildSection(
                      context,
                      title: 'Foodbank location name',
                      content: foodbankData['foodbankName'],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      title: 'Address',
                      content: foodbankData['address'],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      title: 'Type of food donated',
                      content: foodbankData['typeofFood'],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      title: 'Contact No',
                      content: foodbankData['contactNo'],
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      title: 'Foodbank Status',
                      content: foodbankData['foodbankStatus'],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        openGoogleMaps(latitude, longitude); // Open location in Google Maps
                      },
                      child: const Text('Open in Google Maps'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user: widget.user),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required String content,
    IconData? icon }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: Colors.black),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: title == 'Contact No'
                  ? InkWell(
                onTap: () {
                  _launchDialer(content); // Launch dialer for contact number
                },
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline, // Link-like appearance
                  ),
                ),
              )
                  : Text(
                content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

}
