import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../controller/foodbankController.dart';
import '../model/userModel.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';
import 'chatbotAI.dart';
import 'foodbankDetail.dart';
import 'supportServicePage.dart';


//foodbank page
class FoodbankPage extends StatefulWidget {
  final User user;
  final  LatLng? currentLocation;
  const FoodbankPage({Key? key, this.currentLocation, required this.user}) : super(key: key);

  @override
  _FoodbankPageState createState() => _FoodbankPageState();
}

class _FoodbankPageState extends State<FoodbankPage> {
  //loading for page
  bool isLoading = true; // Loading state

  // For displaying map
  final Location _locationController = Location();
  late GoogleMapController _mapController;

  // Fetching nearby foodbanks
  final FoodBank foodbankController = FoodBank();
  late Future<List<Map<String, dynamic>>> nearbyFoodbank;
  // For markers
  Set<Marker> _foodbankMarkers = {}; // Set to store markers

  // State dropdown options
  final List<String> states = ['All', 'Johor', 'Melaka'];
  String selectedState = 'All';

  void _fetchFoodbanks(String state) {
    if (widget.currentLocation != null) {
      // Ensure nearbyFoodbank is assigned a proper Future
      nearbyFoodbank = foodbankController.fetchNearbyFoodbanks(widget.currentLocation!.latitude, widget.currentLocation!.longitude, state).then((value) {
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
  }

  // Add markers to the map
  void _addMarkers(List<Map<String, dynamic>> foodbanks) {
    Set<Marker> newMarkers = {};
    for (var foodbank in foodbanks) {
      String placeId = foodbank['id'];
      String placeName = foodbank['foodbankname'];
      double latitude = foodbank['latitude'];
      double longitude = foodbank['longitude'];

      newMarkers.add(
        Marker(
          markerId: MarkerId(placeId),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: placeName,
            snippet: 'Lat: $latitude, Lng: $longitude',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodbankDetailPage(foodbankID: placeId, currentLocation: widget.currentLocation, user: widget.user), // Navigate to a details page
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
    _fetchFoodbanks(selectedState);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Display loading animation
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SupportServicePage(
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Nearby Foodbanks',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tap the red mark to view nearby foodbanks.',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
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
              child: widget.currentLocation == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.currentLocation!,
                  zoom: 11,
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
          ),
          // State Selection Section
          // State Dropdown Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select State:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                DropdownButton<String>(
                  value: selectedState,
                  isExpanded: true,
                  items: states.map((String state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => selectedState = newValue);
                      _fetchFoodbanks(newValue);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FoodbankDetailPage(foodbankID: foodbank['id'], currentLocation: widget.currentLocation, user: widget.user) // Pass the foodbank id,
                              ),
                            );
                          },
                          child: _buildFoodbankCard(
                            context,
                            imagePath: foodbank['image_url'],
                            name: foodbank['foodbankname'],
                            status: foodbank['foodbankstatus'],
                            distance: foodbank['distance'],
                          ));
                    },
                  );
                }
              },
            ),
          ),
        ],
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

  Widget _buildCategoryChip(String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle filter action
      },
      child: Chip(
        label: Text(label, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }
}

  Widget _buildFoodbankCard(BuildContext context, {
    required String imagePath,
    required String name,
    required String status,
    required String distance,
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
                  ? Image.network(
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
                  status,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                  ),
                ),
                Text(
                  distance,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }