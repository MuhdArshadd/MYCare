import 'package:flutter/material.dart';
import 'chatbotAI.dart';
import 'medicalService.dart'; // Import the MedicalService page
import 'bottomNavigationBar.dart';
import '../model/userModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'supportServicePage.dart'; // Import the SupportServicePage
import 'appBar.dart';

class CategoryMedicalService extends StatelessWidget {
  final User user; // Pass the User object
  final LatLng? currentLocation;

  const CategoryMedicalService({Key? key, required this.user, this.currentLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: user),
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
      bottomNavigationBar: BottomNavWrapper(
        currentIndex: 2, // Set the index for "Support Service"
        user: user, // Pass the User object
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.0), // Add some spacing below AppBar
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SupportServicePage(user: user)));
                          },
                          child: const Icon(Icons.arrow_back, size: 20),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Medical Service',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'NGO',
                    imagePath: 'assets/ngo_icon.png',
                    color: Colors.blue[100],
                  ),
                  SizedBox(height: 20.0),
                  _buildCategoryCard(
                    context,
                    title: 'Government',
                    imagePath: 'assets/government_icon.png',
                    color: Colors.green[100],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
//
  Widget _buildCategoryCard(BuildContext context, {
    required String title,
    required String imagePath,
    required Color? color,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80.0, width: 80.0), // Center the image above
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicalService(
                      category: title,
                      user: user, // Pass the User object
                      currentLocation: currentLocation, // Replace with actual location
                    ),
                  ),
                );
              },
              child: Text('Explore'),
            ),
          ],
        ),
      ),
    );
  }
}
