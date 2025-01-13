import 'package:flutter/material.dart';
import 'coursesDetails.dart';
import 'coursecard.dart';

class LanguageLearningCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Language Learning Courses', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          CourseCard(
            title: "Spanish for Beginners",
            level: "Beginner",
            duration: "5 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Spanish for Beginners",
                    courseUrl: "https://www.example.com/spanish-course",
                    platform: "Duolingo",
                    deliveryMode: "Mobile App",
                    priceInfo: "Free",
                  ),
                ),
              );
            },
          ),
          CourseCard(
            title: "English for Common Interactions in the workplace",
            level: "Basic",
            duration: "3 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Spanish for Beginners",
                    courseUrl: "https://www.example.com/spanish-course",
                    platform: "Duolingo",
                    deliveryMode: "Mobile App",
                    priceInfo: "Free",
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
