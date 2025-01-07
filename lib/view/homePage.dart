import 'package:flutter/material.dart';
import 'package:workshop2dev/view/appBar.dart';
import '../model/userModel.dart';
import 'newsPage.dart';
import 'supportServicePage.dart';
import 'forumPage.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          "MyCare",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome, ${widget.user.fullname}! Checkout below",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewsPage(user: widget.user)),
                      );
                    },
                  ),
                  _buildNavButton(
                    icon: Icons.support_agent,
                    label: "Support Service",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SupportServicePage(user: widget.user)),
                      );
                    },
                  ),
                  _buildNavButton(
                    icon: Icons.forum,
                    label: "Forum",
                    onTap: () {
                      Navigator.push(
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
                children: const [
                  Text(
                    "News Highlight",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  NewsHighlightCard(
                    headline: "Golongan B40 pelajar IPT di bawah KPT terima peranti siswa 2022",
                    imagePath: 'assets/news1.png',
                  ),
                  SizedBox(height: 10),
                  NewsHighlightCard(
                    headline: "Bantuan E-Tunai belia rahmah bernilai RM200 khusus untuk golongan belia",
                    imagePath: 'assets/news2.png',
                  ),
                  SizedBox(height: 10),
                  NewsHighlightCard(
                    headline: "Golongan B40 pelajar IPT di bawah KPT terima peranti siswa 2022",
                    imagePath: 'assets/news3.png',
                  ),
                ],
              ),
            ),
          ],
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
            child: Image.asset(
              imagePath,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
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
