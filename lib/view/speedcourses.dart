import 'package:flutter/material.dart';
import 'coursesDetails.dart'; // Ensure this file exists

class SpeedCourses extends StatefulWidget {
  @override
  _SpeedCoursesState createState() => _SpeedCoursesState();
}

class _SpeedCoursesState extends State<SpeedCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('SPEED Courses', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          CourseCard(
            title: "Peneraju Skil SPEED Expert Mechatronic Integrated System",
            level: "Intermediate",
            duration: "2 months",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Peneraju Skil SPEED Expert Mechatronic Integrated System",
                    courseUrl: "https://www.example.com/mechatronics-course",
                    coursePlatform: "MISDEC, Melaka",
                    deliveryMode: "Physical",
                    priceInfo: "Free for all, Registration Required",
                  ),
                ),
              );
            },
          ),
          CourseCard(
            title: "Peneraju Skil SPEED ECP Mechatronic System",
            level: "Intermediate",
            duration: "2 months",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Peneraju Skil SPEED ECP Mechatronic System",
                    courseUrl: "https://www.example.com/mechatronics-course-ecp",
                    coursePlatform: "MISDEC, Melaka",
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
