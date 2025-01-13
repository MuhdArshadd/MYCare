import 'package:flutter/material.dart';
import 'coursesDetails.dart';

class BusinessCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Text('Business Courses', style: TextStyle(color: Colors.white)),
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
              padding: const EdgeInsets.all(8.0),
              children: [
                CourseCard(
                  title: "Business Analysis & Process Management",
                  level: "Beginner",
                  duration: "2 hours",
                  imageUrl: null, // Leave the imageUrl as null for now
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetails(
                          courseTitle: "Business Analysis & Process Management",
                          courseUrl:
                          "https://www.coursera.org/projects/business-analysis-process-management",
                          coursePlatform: "Coursera",
                          deliveryMode: "Online Classroom",
                          priceInfo: "Free for all, Registration Required",
                          imageUrl: null, // Pass null for now
                        ),
                      ),
                    );
                  },
                ),
                CourseCard(
                  title: "Financial Accounting for Managers",
                  level: "Intermediate",
                  duration: "4 hours",
                  imageUrl: null, // Leave the imageUrl as null for now
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetails(
                          courseTitle: "Financial Accounting for Managers",
                          courseUrl:
                          "https://www.edx.org/course/financial-accounting-for-managers",
                          coursePlatform: "edX",
                          deliveryMode: "Online",
                          priceInfo: "Free to audit, certificate available for a fee",
                          imageUrl: null, // Pass null for now
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
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.business, size: 40, color: Colors.blue.shade700),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Level: $level",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    Text(
                      "Duration: $duration",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
