import 'package:flutter/material.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';
import 'foodbankDetail.dart';

void main() {
  runApp(const MaterialApp(home: FoodbankPage()));
}

class FoodbankPage extends StatelessWidget {
  const FoodbankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
              child: const Center(child: Text("Map Placeholder")),
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
                  // Navigate to "See All" Page
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
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
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
