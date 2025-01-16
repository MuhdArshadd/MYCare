import 'package:flutter/material.dart';
import 'package:workshop2dev/controller/newsController.dart';
import '../model/userModel.dart';
import 'chatbotAI.dart';
import 'newsPage.dart';
import 'supportServicePage.dart';
import 'forumPage.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> newsHighlights = [];

  @override
  void initState() {
    super.initState();
    _fetchNewsHighlights();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Enhanced Styling
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Welcome, ",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    TextSpan(
                      text: widget.user.fullname,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        shadows: [Shadow(blurRadius: 2.0, color: Colors.grey, offset: Offset(1.0, 1.0))],
                      ),
                    ),
                    TextSpan(
                      text: "!\n", // Line break
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    TextSpan(
                      text: "Check out below",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),


            // Program Bootcamp Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        'assets/bootcamp_image.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "PROGRAM BOOTCAMP",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          SizedBox(height: 8),
                          Text("- Skill area: Engineering\n- Training method: Coaching\n- Age: 17-35 years old\n- 1 Aug 2024\n- 8:00 AM\n- RECSAM, Pulau Pinang\n- Certificate provided"),
                          SizedBox(height: 8),
                          Text(
                            "1 available seat left",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Navigation Buttons Section
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
                              headline: news['title'],
                              imagePath: news['image_url'],
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
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2, // Adjust width as needed
        height: MediaQuery.of(context).size.width * 0.2, // Adjust height as needed
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
          child: Image.asset(
            'assets/icon_chatbot.png',
            width: MediaQuery.of(context).size.width * 0.3,  // 10% of screen width
            height: MediaQuery.of(context).size.width * 0.3, // 10% of screen width
          ),
          tooltip: 'Open Chatbot',
        ),
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

  const NewsHighlightCard({Key? key, required this.headline, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }
}
