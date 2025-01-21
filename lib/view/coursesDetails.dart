import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'appBar.dart';
import '../model/userModel.dart';
import 'bottomNavigationBar.dart';

class CourseDetails extends StatefulWidget {
  final String courseTitle;
  final String courseUrl;
  final String coursePlatform;
  final String deliveryMode;
  final String priceInfo;
  final String? imageUrl; // Add this property for the course image URL
  final String courseEducator;
  final User user;

  const CourseDetails({
    required this.courseTitle,
    required this.courseUrl,
    required this.coursePlatform,
    required this.deliveryMode,
    required this.priceInfo,
    this.imageUrl, required this.courseEducator,
    required this.user,// Accept image URL as an optional parameter
  });

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool isFavorite = false; // State to track if the course is marked as favorite

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, size: 24),
                  SizedBox(width: 5),
                  SizedBox(height: 5,),
                ],
              ),
            ),
            // Top banner with dynamic image or default gradient
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: widget.imageUrl == null // Use gradient if imageUrl is null
                    ? LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade400],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
                    : null,
              ),
              child: widget.imageUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Image.network(
                  widget.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
                  : Center(
                child: Icon(Icons.school, size: 100, color: Colors.white),
              ),
            ),
            // Course details section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.courseTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  // buildDetailCard(
                  //   icon: Icons.link,
                  //   title: "Course URL",
                  //   description: widget.courseUrl,
                  //   onTap: () => _launchURL(context, widget.courseUrl),
                  // ),
                  buildDetailCard(
                    icon: Icons.school,
                    title: "Platform",
                    description: widget.coursePlatform,
                  ),
                  buildDetailCard(
                    icon: Icons.school,
                    title: "Educator",
                    description: widget.courseEducator,
                  ),
                  buildDetailCard(
                    icon: Icons.delivery_dining,
                    title: "Delivery Mode",
                    description: widget.deliveryMode,
                  ),
                  buildDetailCard(
                    icon: Icons.checklist,
                    title: "Requirement",
                    description: widget.priceInfo,
                  ),
                  SizedBox(height: 24),
                  // Enroll Now button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                    onPressed: () => _launchURL(context, widget.courseUrl),
                    child: Text(
                      "Enroll Now",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
              )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user: widget.user),

    );
  }

  Widget buildDetailCard({
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade100,
                child: Icon(icon, size: 28, color: Colors.blue.shade700),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.open_in_new, size: 24, color: Colors.blue.shade800),
            ],
          ),
        ),
      ),
    );
  }


  void _launchURL(BuildContext context, String url) async {
    // Show a Snackbar indicating the URL is opening
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening $url")),
    );

    // Check if the URL can be launched
    if (await canLaunch(url)) {
      // Launch the URL in the phone's default browser
      await launch(url);
    } else {
      // If the URL can't be launched, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the URL")),
      );
    }
  }

}
