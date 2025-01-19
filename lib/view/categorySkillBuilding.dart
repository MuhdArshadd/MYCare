import 'package:flutter/material.dart';
import 'chatbotAI.dart';
import 'onlineCourses.dart';
import 'physicalCourses.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import '../model/userModel.dart';
import 'supportServicePage.dart';

class CategorySkillBuilding extends StatelessWidget {
  final User user;

  const CategorySkillBuilding({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SupportServicePage(user: user)));
                        },
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Skill Building',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCategoryCard(
                    context,
                    'Online Courses',
                    'assets/onlineCourses.png',
                    Colors.blue.shade50,
                    OnlineCoursesPage(user: user),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
                    context,
                    'Physical Courses',
                    'assets/physicalCourses.png',
                    Colors.green.shade50,
                    PhysicalCoursesPage(user: user),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Image.asset('assets/icon_chatbot.png'),
        tooltip: 'Open Chatbot',
      ),
      bottomNavigationBar: BottomNavWrapper(
        currentIndex: 2,
        user: user,
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context,
      String title,
      String assetPath,
      Color backgroundColor,
      Widget nextPage,
      ) {
    return Card(
      elevation: 4,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nextPage),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                elevation: 2,
              ),
              child: const Text('Explore'),
            ),
          ],
        ),
      ),
    );
  }
}
