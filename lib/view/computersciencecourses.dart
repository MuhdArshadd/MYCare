import 'package:flutter/material.dart';
import 'coursesDetails.dart';
import 'coursecard.dart';

class ComputerScienceCourses extends StatefulWidget {
  @override
  _ComputerScienceCoursesState createState() => _ComputerScienceCoursesState();
}

class _ComputerScienceCoursesState extends State<ComputerScienceCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Computer Science Courses',
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
                          coursePlatform: "edX",
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
