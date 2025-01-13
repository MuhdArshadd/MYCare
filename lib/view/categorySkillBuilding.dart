import 'package:flutter/material.dart';
import 'onlineCourses.dart';
import 'physicalCourses.dart';
import 'appBar.dart'; // Import the Custom AppBar
import 'bottomNavigationBar.dart';
import '../model/userModel.dart';
import 'supportServicePage.dart'; // Import SupportServicePage

class CategorySkillBuilding extends StatelessWidget {
  final User user;

  const CategorySkillBuilding({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Skill Building', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // When back is pressed, navigate to SupportServicePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SupportServicePage(user: user),
              ),
            );
          },  // Navigate to SupportServicePage on back press
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(
        currentIndex: 2,  // Set the index for "Support Service"
        user: user,  // Pass the User object
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCategoryCard(
                    context,
                    'Online Courses',
                    'assets/onlineCourses.png',
                    Colors.pink.shade50,  // Adding pink background
                    OnlineCoursesPage(),
                  ),
                  _buildCategoryCard(
                    context,
                    'Physical Courses',
                    'assets/physicalCourses.png',
                    Colors.green.shade50,  // Adding green background
                    PhysicalCoursesPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, String assetPath, Color backgroundColor, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Card(
        elevation: 4,
        color: backgroundColor,  // Apply the background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, height: 80),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
