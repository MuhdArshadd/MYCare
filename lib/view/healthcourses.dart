import 'package:flutter/material.dart';
import 'coursesDetails.dart';
import 'coursecard.dart';

class HealthCourses extends StatefulWidget {
  @override
  _HealthCoursesState createState() => _HealthCoursesState();
}

class _HealthCoursesState extends State<HealthCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Health Courses',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "List of courses available",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          Expanded(
            child: ListView(
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
                          coursePlatform: "Coursera",
                          deliveryMode: "Online Video",
                          priceInfo: "Free with optional paid certificate",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
