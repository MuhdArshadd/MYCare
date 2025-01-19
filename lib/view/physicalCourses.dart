import 'package:flutter/material.dart';
import 'skillCourses.dart';
import 'technologycourses.dart';
import 'speedcourses.dart';
import '../model/userModel.dart';
import 'appBar.dart';
import 'categorySkillBuilding.dart';
import 'bottomNavigationBar.dart';

class PhysicalCoursesPage extends StatefulWidget {
  final User user;

  const PhysicalCoursesPage({Key? key, required this.user}) : super(key: key);
  @override
  _PhysicalCoursesPageState createState() => _PhysicalCoursesPageState();
}

class _PhysicalCoursesPageState extends State<PhysicalCoursesPage> {
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
            SizedBox(height: 8,),
            Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildCategoryCard(context, 'Skill', 'assets/skil.png', SkillCourses(user: widget.user,)),
                  _buildCategoryCard(context, 'Technology', 'assets/technology.png', TechnologyCourses(user: widget.user,)),
                  _buildCategoryCard(context, 'SPEED', 'assets/speed.png', SpeedCourses(user: widget.user,)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user: widget.user),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, String assetPath, Widget? targetPage) {
    return GestureDetector(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        }
      },
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
