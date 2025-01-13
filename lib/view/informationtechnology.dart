import 'package:flutter/material.dart';
import 'coursesDetails.dart';
import 'coursecard.dart';

class InformationTechnology extends StatefulWidget {
  @override
  _InformationTechnologyState createState() => _InformationTechnologyState();
}

class _InformationTechnologyState  extends State<InformationTechnology> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Information Technology Courses',
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
                  title: "ChatGPT Playground for Beginners: Intro to NLP AI",
                  level: "Beginner",
                  duration: "2 hours",
                  imageUrl: null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetails(
                          courseTitle: "ChatGPT Playground for Beginners: Intro to NLP AI",
                          courseUrl: "https://www.coursera.org/projects/rudi-hinds-chatgpt-playground-for-beginners-intro-to-nlp-ai",
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
