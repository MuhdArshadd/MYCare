import 'package:flutter/material.dart';
import 'coursesDetails.dart'; // Ensure this file exists

class BusinessCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Business Courses', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          CourseCard(
            title: "Business Analysis & Process Management",
            level: "Beginner",
            duration: "2 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Business Analysis & Process Management",
                    courseUrl: "https://www.coursera.org/projects/business-analysis-process-management",
                    platform: "Coursera",
                    deliveryMode: "Online Classroom",
                    priceInfo: "Free for all, Registration Required",
                  ),
                ),
              );
            },
          ),
          CourseCard(
            title: "Financial Accounting for Managers",
            level: "Intermediate",
            duration: "4 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Financial Accounting for Managers",
                    courseUrl: "https://www.edx.org/course/financial-accounting-for-managers",
                    platform: "edX",
                    deliveryMode: "Online",
                    priceInfo: "Free to audit, certificate available for a fee",
                  ),
                ),
              );
            },
          ),
          CourseCard(
            title: "Project Management Professional",
            level: "Advanced",
            duration: "8 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Project Management Professional",
                    courseUrl: "https://www.udemy.com/course/project-management-professional-pmp-exam-prep/",
                    platform: "Udemy",
                    deliveryMode: "Self-paced",
                    priceInfo: "Paid course, discounts available",
                  ),
                ),
              );
            },
          ),
          CourseCard(
            title: "Entrepreneurship Essentials",
            level: "Beginner",
            duration: "6 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Entrepreneurship Essentials",
                    courseUrl: "https://www.coursera.org/learn/entrepreneurship-essentials",
                    platform: "Coursera",
                    deliveryMode: "Online Classroom",
                    priceInfo: "Free for all, Registration Required",
                  ),
                ),
              );
            },
          ),
          CourseCard(
            title: "Leadership & Management",
            level: "Intermediate",
            duration: "5 hours",
            imageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetails(
                    courseTitle: "Leadership & Management",
                    courseUrl: "https://www.edx.org/course/leadership-and-management",
                    platform: "edX",
                    deliveryMode: "Online",
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
