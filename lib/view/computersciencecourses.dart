import 'package:flutter/material.dart';
import 'coursesDetails.dart';
import 'coursecard.dart';

class ComputerScienceCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Computer Science Courses', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          CourseCard(
            title: "Cybersecurity for Everyone",
            level: "Advanced",
            duration: "8 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Introduction to Algorithms",
                    courseUrl: "https://www.example.com/algorithms-course",
                    platform: "edX",
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
