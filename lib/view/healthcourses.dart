import 'package:flutter/material.dart';
import 'coursesDetails.dart';
import 'coursecard.dart';

class HealthCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Health Courses', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          CourseCard(
            title: "Nutrition Basics",
            level: "Intermediate",
            duration: "3 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Nutrition Basics",
                    courseUrl: "https://www.example.com/nutrition-course",
                    platform: "Coursera",
                    deliveryMode: "Online Video",
                    priceInfo: "Free with optional paid certificate",
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
