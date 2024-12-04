import 'package:flutter/material.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'skillDetailsPage.dart';

class SkillBuildingPage extends StatefulWidget {
  @override
  _SkillBuildingPageState createState() => _SkillBuildingPageState();
}

class _SkillBuildingPageState extends State<SkillBuildingPage> {
  String searchQuery = ""; // Variable to store the search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Custom AppBar
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button and Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Skill Building Programme",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query
                });
              },
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
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
                  'assets/skillsmalaysia_logo.png',
                  height: 150,
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
                _buildCategoryCard('Technical', Icons.engineering),
                _buildCategoryCard('Business', Icons.bar_chart),
                _buildCategoryCard('Technology', Icons.computer),
                _buildCategoryCard('Career Development', Icons.school),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2), // Custom Bottom Nav
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return InkWell(
      onTap: () {
        // Navigate or handle tap
        if (title == 'Technical')
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SkillDetailsPage(),
              ),
            );
          }
        print('Tapped on $title');
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
