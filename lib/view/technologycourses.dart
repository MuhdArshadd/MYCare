import 'package:flutter/material.dart';
import 'coursesDetails.dart'; // Ensure this file exists

class TechnologyCourses extends StatefulWidget {
  @override
  _TechnologyCoursesState createState() => _TechnologyCoursesState();
}

class _TechnologyCoursesState extends State<TechnologyCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Technology Courses', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          CourseCard(
            title: "Artificial Intelligence and Machine Learning Competence for Industry 4.0",
            level: "Expert",
            duration: "2 months",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Artificial Intelligence and Machine Learning Competence for Industry 4.0",
                    courseUrl: "https://www.example.com/ai-course",
                    coursePlatform: "SHRDC, Selangor",
                    deliveryMode: "Physical",
                    priceInfo: "Free for all, Registration Required",
                  ),
                ),
              );
            },
          ),
          CourseCard(
            title: "Certified Cloud Operations Associate",
            level: "Intermediate",
            duration: "1 month",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Certified Cloud Operations Associate",
                    courseUrl: "https://www.example.com/cloud-course",
                    coursePlatform: "Sarawak Skills, Sarawak",
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
