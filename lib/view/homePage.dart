import 'package:flutter/material.dart';
import 'package:workshop2dev/controller/newsController.dart';
import '../model/userModel.dart';
import 'chatbotAI.dart';
import 'newsPage.dart';
import 'supportServicePage.dart';
import 'forumPage.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'package:workshop2dev/controller/skillsController.dart';
import 'coursesDetails.dart';
import 'newsDetailPage.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> newsHighlights = [];
  List<Map<String, dynamic>> skillsHighlights = [];


  @override
  void initState() {
    super.initState();
    _fetchNewsHighlights();
    _fetchSkillHighlights();

  }

  Future<void> _fetchNewsHighlights() async {
    try {
      News newsModel = News();
      List<Map<String, dynamic>> fetchedNews = await newsModel.fetchNews();
      setState(() {
        newsHighlights = fetchedNews.take(5).toList(); // Limit to 5 news highlights
      });
    } catch (e) {
      print('Error fetching news highlights: $e');
    }
  }


  Future<void> _fetchSkillHighlights() async {
    try {
      SkillsController skillModel = SkillsController();
      List<Map<String, dynamic>> fetchedSkills = await skillModel.fetchSkillsOnline();
      setState(() {
        skillsHighlights = fetchedSkills.take(5).toList(); // Limit to 5 skills highlights
      });
    } catch (e) {
      print('Error fetching skill highlights: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Welcome, ",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    TextSpan(
                      text: widget.user.fullname,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        shadows: [Shadow(blurRadius: 2.0, color: Colors.grey, offset: Offset(1.0, 1.0))],
                      ),
                    ),
                    TextSpan(
                      text: "!\nCheck out below",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            // Sliding Bootcamp Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 320,
                child: PageView.builder(
                  itemCount: skillsHighlights.length,
                  controller: PageController(viewportFraction: 0.8),
                  itemBuilder: (context, index) {
                    final skillsOnline = skillsHighlights[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SkillsHighlightCard(
                        imagePath: skillsOnline['image'] ?? '',
                        skillName: skillsOnline['name'] ?? '',
                        organizer: skillsOnline['educator'] ?? 'No Organizer',
                        criteria: skillsOnline['criteria'] ?? 'No Criteria',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetails(
                                  courseTitle: skillsOnline['name'],
                                  courseUrl: skillsOnline['link'],
                                  coursePlatform: skillsOnline['organizer'],
                                  deliveryMode: skillsOnline['venue'],
                                  priceInfo: skillsOnline['criteria'] ?? 'No criteria available',
                                  imageUrl: skillsOnline['image'],
                                  courseEducator: skillsOnline['educator']
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavButton(
                    icon: Icons.article,
                    label: "News",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => NewsPage(user: widget.user)),
                      );
                    },
                  ),
                  _buildNavButton(
                    icon: Icons.support_agent,
                    label: "Support Service",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SupportServicePage(user: widget.user)),
                      );
                    },
                  ),
                  _buildNavButton(
                    icon: Icons.forum,
                    label: "Forum",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ForumPage(user: widget.user)),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // News Highlights Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "News Highlight",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (newsHighlights.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: newsHighlights.length,
                        itemBuilder: (context, index) {
                          final news = newsHighlights[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: NewsHighlightCard(
                              headline: news['title'] ?? 'No Title',
                              imagePath: news['image_url'] ?? '',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetailPage(
                                        article: news, user: widget.user),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 0, user: widget.user),
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
    );

  }

  Widget _buildNavButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class NewsHighlightCard extends StatelessWidget {
  final String headline;
  final String imagePath;
  final VoidCallback onTap;

  const NewsHighlightCard({Key? key, required this.headline,
    required this.imagePath,
    required this.onTap,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card( // Wrap with Card for elevation support
      elevation: 4, // Set elevation here
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: Image.network(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                headline,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillsHighlightCard extends StatelessWidget {
  final String skillName;
  final String imagePath;
  final String organizer;
  final String criteria;
  final VoidCallback onTap;

  const SkillsHighlightCard({
    Key? key,
    required this.skillName,
    required this.imagePath,
    required this.organizer,
    required this.criteria,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                imagePath,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 120);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skillName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    organizer,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    criteria,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
