import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';
import 'foodbankDetail.dart';

void main() {
  runApp(const MaterialApp(home: FoodbankPage()));
}

class FoodbankPage extends StatefulWidget {
  const FoodbankPage({Key? key}) : super(key: key);

  @override
  _FoodbankPageState createState() => _FoodbankPageState();
}

class _FoodbankPageState extends State<FoodbankPage> {
  Location _locationController = Location();
  LatLng? currentLocation;
  late GoogleMapController _mapController;

  //Request location permission and get the current location
  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location service is enabled
    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        print('Location service is not enabled.');
        return;
      }
    }

    // Request permission
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Location permission denied');
        return;
      }
    }

    // Get the current location
    try {
      final locationData = await _locationController.getLocation();
      setState(() {
        currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
      print('Current Location in: Latitude: ${currentLocation!.latitude}, Longitude: ${currentLocation!.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch the location as soon as the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.arrow_back, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Foodbank',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          // Map Section
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[300],
              ),
              child: currentLocation == null ? const Center(child: CircularProgressIndicator()) // Loading until location is fetched
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation!,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
              ),
            ),
          ),
          // Nearby Foodbanks Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text(
              'Nearby Foodbanks',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFoodbankCard(
                  context,
                  imagePath: 'assets/images/petronas.jpg',
                  name: 'Petronas Durian Tunggal',
                  category: 'Makanan Kering',
                ),
                _buildFoodbankCard(
                  context,
                  imagePath: 'assets/images/cuitcekup.jpg',
                  name: 'Cuit Cekup Mini Mart & Bakery',
                  category: 'Makanan Kering',
                ),
              ],
            ),
          ),
          // See All Button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FoodbankDetailPage()),
                  );
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavWrapper(currentIndex: 2),
    );
  }

  Widget _buildFoodbankCard(
      BuildContext context, {
        required String imagePath,
        required String name,
        required String category,
      }) {
    return Container(
      width: 200.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FoodbankDetailPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Open',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
