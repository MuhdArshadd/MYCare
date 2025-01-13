import 'package:flutter/material.dart';
import 'coursesDetails.dart';
import 'coursecard.dart';

class PersonalDevelopment extends StatefulWidget {
  @override
  _PersonalDevelopmentState createState() => _PersonalDevelopmentState();
}

class _PersonalDevelopmentState extends State<PersonalDevelopment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Personal Development Courses',
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
                  title: "Adobe Premiere Pro for Beginners: Quickstart Video-Editing",
                  level: "Beginner",
                  duration: "1.5 hours",
                  imageUrl: null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetails(
                          courseTitle: "Adobe Premiere Pro for Beginners: Quickstart Video-Editing",
                          courseUrl: "https://www.coursera.org/projects/adobe-premiere-pro-for-beginners-quickstart-video-editing",
                          coursePlatform: "Coursera",
                          deliveryMode: "Hands On Learning",
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
