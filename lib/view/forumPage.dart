import 'package:flutter/material.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';

class ForumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Ensure CustomAppBar is properly defined
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.lightBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {}, // Add your action here
                  child: Text(
                    "Latest",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {}, // Add your action here
                  child: Text(
                    "Trending",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {}, // Add your action here
                  child: Text(
                    "Popular This Week",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Forum List
          Expanded(
            child: ListView(
              children: [
                ForumCard(
                  question: "Where is a good place to eat with family?",
                  answers: 0,
                  votes: 0,
                  views: 15,
                  timeAgo: "23m ago",
                ),
                ForumCard(
                  question: "I'm 23 years old, can you suggest what important skills should I learn? I have a lot of free time.",
                  answers: 5,
                  votes: 20,
                  views: 478,
                  timeAgo: "3h ago",
                ),
                ForumCardWithImage(
                  question: "New eco opened at durian tunggal recently",
                  imageUrl: "assets/logo.png", // Ensure this asset is available
                  answers: 2,
                  votes: 68,
                  views: 727,
                  timeAgo: "24h ago",
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 3), // Make sure this is properly defined
    );
  }
}

class ForumCard extends StatelessWidget {
  final String question;
  final int answers;
  final int votes;
  final int views;
  final String timeAgo;

  ForumCard({
    required this.question,
    required this.answers,
    required this.votes,
    required this.views,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$answers Answers  •  $votes Votes  •  $views Views"),
                Text(timeAgo, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ForumCardWithImage extends StatelessWidget {
  final String question;
  final String imageUrl;
  final int answers;
  final int votes;
  final int views;
  final String timeAgo;

  ForumCardWithImage({
    required this.question,
    required this.imageUrl,
    required this.answers,
    required this.votes,
    required this.views,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$answers Answers  •  $votes Votes  •  $views Views"),
                    Text(timeAgo, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
