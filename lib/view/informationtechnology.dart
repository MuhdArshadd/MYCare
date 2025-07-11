import 'package:flutter/material.dart';
import '../controller/skillsController.dart';
import 'coursesDetails.dart';
import 'bottomNavigationBar.dart';
import '../model/userModel.dart';
import 'onlineCourses.dart';
import 'appBar.dart';

class InformationTechnology extends StatefulWidget {
  final User user;

  const InformationTechnology({Key? key, required this.user}) : super(key: key);
  @override
  _InformationTechnologyState createState() => _InformationTechnologyState();
}

class _InformationTechnologyState  extends State<InformationTechnology> {

  final SkillsController skillsController = SkillsController();
  String learning_type = "Online";
  String category = "Information Technology";

  // This will hold the future to fetch the courses
  late Future<List<Map<String, dynamic>>> coursesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future
    coursesFuture = skillsController.fetchSkills(learning_type, category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(user: widget.user),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OnlineCoursesPage(user: widget.user)));
            },
            child: Row(
              children: const [
                Icon(Icons.arrow_back, size: 24),
                SizedBox(width: 8),
              ],
            ),
          ),
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: coursesFuture, // The future to fetch the courses
              builder: (context, snapshot) {
                // Check the connection state of the Future
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading spinner while data is being fetched
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Show an error message if something went wrong
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  // When data is available, display the courses
                  List<Map<String, dynamic>> courses = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return CourseCard(
                        title: course['name'],  // Updated to match data
                        level: course['level'],  // Updated to match data
                        duration: course['duration'],  // Updated to match data
                        imageUrl: course['image'],  // Updated to match data
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetails(user: widget.user,
                                  courseTitle: course['name'],  // Updated to match data
                                  courseUrl: course['link'],  // Updated to match data
                                  coursePlatform: course['organizer'],  // Updated to match data
                                  deliveryMode: course['venue'],  // Updated to match data
                                  priceInfo: course['criteria'] ?? 'No criteria available', // Criteria as a formatted string
                                  imageUrl: course['image'],  // Updated to match data
                                  courseEducator: course['educator']
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  // Handle case when there is no data
                  return Center(child: Text('No courses available'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user: widget.user),
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
