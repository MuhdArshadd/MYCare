import 'package:flutter/material.dart';
import 'BusinessCourses.dart';
import 'informationtechnology.dart';
import 'computersciencecourses.dart';
import 'personaldevelopment.dart';
import 'appBar.dart';
import '../model/userModel.dart';
import 'categorySkillBuilding.dart';
import 'bottomNavigationBar.dart';

class OnlineCoursesPage extends StatefulWidget {
  final User user;

  const OnlineCoursesPage({Key? key, required this.user}) : super(key: key);

  @override
  _OnlineCoursesPageState createState() => _OnlineCoursesPageState();
}

class _OnlineCoursesPageState extends State<OnlineCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategorySkillBuilding(user: widget.user)));
              },
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, size: 24),
                  SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Text(
              'Categories',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildCategoryCard(
                      context, 'Business', 'assets/business icon.png', BusinessCourses(user: widget.user,)),
                  _buildCategoryCard(
                      context, 'Computer Science', 'assets/computer_science.png', ComputerScienceCourses(user:widget.user,)),
                  _buildCategoryCard(
                      context, 'Information Technology', 'assets/information_technology.png', InformationTechnology(user: widget.user,)),
                  _buildCategoryCard(
                      context, 'Personal Development', 'assets/personal_development.png', PersonalDevelopment(user: widget.user,)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user:widget.user ),
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
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
