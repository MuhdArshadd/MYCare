import 'package:flutter/material.dart';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'skillDetailsPage.dart';

class SkillBuildingPage extends StatefulWidget {
  final User user;
  const SkillBuildingPage({super.key, required this.user});

  @override
  _SkillBuildingPageState createState() => _SkillBuildingPageState();
}

class _SkillBuildingPageState extends State<SkillBuildingPage> {
  String searchQuery = ""; // Variable to store the search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user), // Custom AppBar
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Centered Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: const Text(
                "Skill Building Programme",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/skillBuilding.png',
                  height: 210,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Categories Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // GridView for Categories
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: [
                _buildCategoryCard('Technical', 'assets/technical.png'),
                _buildCategoryCard('Business', 'assets/business.png'),
                _buildCategoryCard('Technology', 'assets/technology.png'),
                _buildCategoryCard('Career Development', 'assets/career.png'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWrapper(
        currentIndex: 2,
        user: widget.user,
      ), // Custom Bottom Nav
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Navigate or handle tap
            String category = title;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SkillDetailsPage(category: category, user: widget.user),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // Makes the image cover the entire container
                height: 120,
                width: double.infinity, // Adjust width to stretch within the grid
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), // Space between the container and title
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
