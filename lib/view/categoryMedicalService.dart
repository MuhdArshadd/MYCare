import 'package:flutter/material.dart';
import 'medicalService.dart'; // Import the MedicalService page
import 'appBar.dart'; // Import the Custom AppBar
import 'bottomNavigationBar.dart';
import '../model/userModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'supportServicePage.dart'; // Import the SupportServicePage

class CategoryMedicalService extends StatelessWidget {
  final User user; // Pass the User object

  const CategoryMedicalService({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        user: user,
        leading: IconButton(  // Add the back button here in CustomAppBar
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to SupportServicePage when back button is pressed
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SupportServicePage(user: user),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavWrapper( // Custom BottomNavigationBar
        currentIndex: 2, // Set the index for "Support Service"
        user: user, // Pass the User object
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Service Category',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: [
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
                      user: user, // Pass the User object
                      currentLocation: LatLng(37.7749, -122.4194), // Replace with actual location
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
