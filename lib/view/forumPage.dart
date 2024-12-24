import 'package:flutter/material.dart';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';

class ForumPage extends StatefulWidget {
  final User user;

  const ForumPage({super.key, required this.user});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  String selectedTab = "Latest";

  void changeTab(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  void _navigateToAddPostPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostPage(noIc: widget.user.userIC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "User ID: ${widget.user.userIC}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.lightBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => changeTab("Latest"),
                  child: Text(
                    "Latest",
                    style: TextStyle(
                      color: selectedTab == "Latest" ? Colors.white : Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => changeTab("Trending"),
                  child: Text(
                    "Trending",
                    style: TextStyle(
                      color: selectedTab == "Trending" ? Colors.white : Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => changeTab("Popular This Week"),
                  child: Text(
                    "Popular This Week",
                    style: TextStyle(
                      color: selectedTab == "Popular This Week" ? Colors.white : Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (selectedTab == "Latest" || selectedTab == "Trending" || selectedTab == "Popular This Week") ...[
                  ForumCard(
                    question: "Where is a good place to eat with family?",
                    answers: 0,
                    votes: 0,
                    views: 15,
                    timeAgo: "23m ago",
                  ),
                  ForumCard(
                    question:
                    "I'm 23 years old, can you suggest what important skills should I learn? I have a lot of free time.",
                    answers: 5,
                    votes: 20,
                    views: 478,
                    timeAgo: "3h ago",
                  ),
                  ForumCardWithImage(
                    profileImage: "assets/profile3.png", // Add appropriate profile image
                    question: "New eco opened at durian tunggal recently",
                    imageUrl: "assets/store_image.png", // Add your image asset path
                    answers: 2,
                    votes: 68,
                    views: 727,
                    timeAgo: "24h ago",
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPostPage,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: "Add Post",
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 3, user: widget.user),
    );
  }
}

class ForumCard extends StatelessWidget {
  final String question;
  final int answers;
  final int votes;
  final int views;
  final String timeAgo;

  const ForumCard({
    required this.question,
    required this.answers,
    required this.votes,
    required this.views,
    required this.timeAgo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$answers Answers  •  $votes Votes  •  $views Views"),
                Text(timeAgo, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ForumCardWithImage extends StatelessWidget {
  final String profileImage;
  final String question;
  final String imageUrl;
  final int answers;
  final int votes;
  final int views;
  final String timeAgo;

  const ForumCardWithImage({
    required this.profileImage,
    required this.question,
    required this.imageUrl,
    required this.answers,
    required this.votes,
    required this.views,
    required this.timeAgo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(profileImage),
                radius: 16,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Image.asset(imageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$answers Answers  •  $votes Votes  •  $views Views"),
                Text(timeAgo, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddPostPage extends StatelessWidget {
  final String noIc;

  const AddPostPage({super.key, required this.noIc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.menu, // This icon represents the three horizontal lines (hamburger menu)
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer when the icon is pressed
              },
            ),
            const SizedBox(width: 10),
            const Text(
              "MyCare",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: Drawer( // Add the drawer here
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Add navigation or functionality here
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Add navigation or functionality here
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create a New Forum Post",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Add functionality to submit post
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
