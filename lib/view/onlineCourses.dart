import 'package:flutter/material.dart';
import 'BusinessCourses.dart';
import 'languagelearning.dart';
import 'computersciencecourses.dart';
import 'healthcourses.dart';

class OnlineCoursesPage extends StatefulWidget {
  @override
  _OnlineCoursesPageState createState() => _OnlineCoursesPageState();
}

class _OnlineCoursesPageState extends State<OnlineCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Online Courses',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header for "Courses provided by Coursera"
            Center(
              child: Text(
                'Courses provided by Coursera',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Categories heading
            Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildCategoryCard(
                      context, 'Business', 'assets/business icon.png', BusinessCourses()),
                  _buildCategoryCard(
                      context, 'Computer Science', 'assets/computer_science.png', ComputerScienceCourses()),
                  _buildCategoryCard(
                      context, 'Language Learning', 'assets/language.png', LanguageLearningCourses()),
                  _buildCategoryCard(
                      context, 'Health', 'assets/health.png', HealthCourses()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, String assetPath, Widget? destination) {
    return GestureDetector(
      onTap: destination != null
          ? () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      )
          : null,
      child: Card(
        elevation: 4,
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
