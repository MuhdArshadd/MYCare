import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';

class FoodbankPage extends StatelessWidget {
  const FoodbankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back and Search Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Location Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                FilterChip(
                  label: const Text('Melaka'),
                  onSelected: (bool selected) {},
                ),
                FilterChip(
                  label: const Text('Selangor'),
                  onSelected: (bool selected) {},
                ),
                FilterChip(
                  label: const Text('Negeri Sembilan'),
                  onSelected: (bool selected) {},
                ),
              ],
            ),
          ),
          // Map Section
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[300],
              ),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(2.2008, 102.2405), // Example coordinates
                  zoom: 11.0,
                ),
                markers: {
                  const Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(2.2008, 102.2405),
                  ),
                },
              ),
            ),
          ),
          // Nearby Foodbanks Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text(
              'Nearby Foodbank',
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
                  imagePath: 'assets/images/petronas.jpg',
                  name: 'Petronas Durian Tunggal',
                  category: 'Makanan Kering',
                ),
                _buildFoodbankCard(
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
                // Add navigation to "See All" page
              },
              child: const Text(
                'see all',
                style: TextStyle(color: Colors.blue,),

              ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
    );
  }

  Widget _buildFoodbankCard({
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
                const Text(
                  'Open',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
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