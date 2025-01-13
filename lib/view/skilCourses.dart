import 'package:flutter/material.dart';
import 'coursesDetails.dart'; // Ensure this file exists

class SkillCourses extends StatefulWidget {
  @override
  _SkillCoursesState createState() => _SkillCoursesState();
}

class _SkillCoursesState extends State<SkillCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Skill Courses', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          CourseCard(
            title: "Multi Axis CNC Machine Process and Programming",
            level: "Intermediate",
            duration: "2 months",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Multi Axis CNC Machine Process and Programming",
                    courseUrl: "https://www.example.com/cnc-course",
                    coursePlatform: "Johor Skills, Johor",
                    deliveryMode: "Physical",
                    priceInfo: "Free for all, Registration Required",
                  ),
                ),
              );
            },
          ),
          CourseCard(
            title: "Drone Piloting and Maintenance",
            level: "Intermediate",
            duration: "2 months",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Drone Piloting and Maintenance",
                    courseUrl: "https://www.example.com/drone-course",
                    coursePlatform: "KISMEC, Kedah",
                    deliveryMode: "Physical",
                    priceInfo: "Free to audit, certificate available for a fee",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Reuse the CourseCard widget
class CourseCard extends StatelessWidget {
  final String title;
  final String level;
  final String duration;
  final String? imageUrl;
  final VoidCallback onTap;

  const CourseCard({
    required this.title,
    required this.level,
    required this.duration,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          leading: imageUrl != null
              ? Image.network(imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
              : Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
          title: Text(title),
          subtitle: Text("Level: $level\nDuration: $duration"),
        ),
      ),
    );
  }
}
