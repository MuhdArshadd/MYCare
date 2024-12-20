import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../controller/foodbankController.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';
import 'foodbankDetail.dart';

//
class FoodbankPage extends StatefulWidget {
  const FoodbankPage({Key? key}) : super(key: key);

  @override
  _FoodbankPageState createState() => _FoodbankPageState();
}

class _FoodbankPageState extends State<FoodbankPage> {
  //loading for page
  bool isLoading = true; // Loading state

  // For displaying map
  final Location _locationController = Location();
  LatLng? currentLocation;
  late GoogleMapController _mapController;

  // Fetching nearby foodbanks
  final FoodBank foodbankController = FoodBank();
  late Future<List<Map<String, dynamic>>> nearbyFoodbank;
  // For markers
  Set<Marker> _foodbankMarkers = {}; // Set to store markers

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

  // Add markers to the map
  void _addMarkers(List<Map<String, dynamic>> foodbanks) {
    Set<Marker> newMarkers = {};
    for (var foodbank in foodbanks) {
      String placeId = foodbank['foodbank_ID']; // Replace with the actual place ID
      String placeName = foodbank['foodbankName']; // Replace with actual foodbank name
      double latitude = foodbank['latitude']; // Replace with actual latitude
      double longitude = foodbank['longitude']; // Replace with actual longitude

      newMarkers.add(
        Marker(
          markerId: MarkerId(placeId),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: placeName,
            snippet: 'Lat: $latitude, Lng: $longitude',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodbankDetailPage(), // Navigate to a details page
                ),
              );
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    setState(() {
      _foodbankMarkers = newMarkers; // Update the markers set
    });
  }


  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((_) {
      if (currentLocation != null) {
        // Ensure nearbyFoodbank is assigned a proper Future
        nearbyFoodbank = foodbankController.fetchNearbyFoodbanks(currentLocation!.latitude, currentLocation!.longitude).then((value) {
          setState(() {
            isLoading = false; // Stop loading once the data is fetched
            _addMarkers(value); // Add markers to the map
          });
          return value; // Return the fetched data
        }).catchError((error) {
          // Handle potential errors here and return an empty list
          print('Error fetching foodbanks: $error');
          return <Map<String, dynamic>>[];
        });
      } else {
        // Assign a default empty list if location is null
        nearbyFoodbank = Future.value(<Map<String, dynamic>>[]);
        setState(() {
          isLoading = false;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Display loading animation
          : Column(
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
              child: currentLocation == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation!,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: _foodbankMarkers, // Display the markers
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: nearbyFoodbank,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No nearby foodbanks found.'));
                } else {
                  final foodbanks = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two cards per row
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.75, // Adjust the aspect ratio to control card height
                    ),
                    itemCount: foodbanks.length,
                    itemBuilder: (context, index) {
                      final foodbank = foodbanks[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FoodbankDetailPage() // Pass the foodbank data,
                              ),
                            );
                          },
                          child: _buildFoodbankCard(
                            context,
                            imagePath: foodbank['imagePlace'],
                            name: foodbank['foodbankName'],
                            category: foodbank['typeofFood'],
                          ));
                    },
                  );
                }
              },
            ),
          ),
          // See All Button
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          //     child: TextButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => const FoodbankDetailPage()),
          //         );
          //       },
          //       child: const Text(
          //         'See All',
          //         style: TextStyle(
          //           color: Colors.blue,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: const BottomNavWrapper(currentIndex: 2),
    );
  }

  Widget _buildFoodbankCard(BuildContext context, {
    required Uint8List imagePath, // Base64 String
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
              child: imagePath != null
                  ? Image.memory(
                imagePath, // Use the decoded image
                fit: BoxFit.cover,
                width: double.infinity,
              )
                  : Image.asset(
                'assets/images/placeholder.png', // Fallback image
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
              ],
            ),
          ),
        ],
      ),
    );
  }

}