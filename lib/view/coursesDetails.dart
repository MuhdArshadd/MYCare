import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  final String courseTitle;
  final String courseUrl;
  final String platform;
  final String deliveryMode;
  final String priceInfo;

  const CourseDetails({
    required this.courseTitle,
    required this.courseUrl,
    required this.platform,
    required this.deliveryMode,
    required this.priceInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.book, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              courseTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildIconRow(Icons.link, 'URL: $courseUrl'),
            SizedBox(height: 10),
            buildIconRow(Icons.school, 'Platform: $platform'),
            SizedBox(height: 10),
            buildIconRow(Icons.delivery_dining, 'Delivery Mode: $deliveryMode'),
            SizedBox(height: 10),
            buildIconRow(Icons.attach_money, 'Price Info: $priceInfo'),
          ],
        ),
      ),
    );
  }

  Widget buildIconRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
