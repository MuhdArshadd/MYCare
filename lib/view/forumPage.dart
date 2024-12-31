import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:workshop2dev/controller/forumController.dart';
import '../model/userModel.dart';
import 'addPost.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'feedDetailsPage.dart';

class ForumPage extends StatefulWidget {
  final User user;
  const ForumPage({super.key, required this.user});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final ForumController _forumController = ForumController();
  String selectedTab = "latest"; // Default tab is "Latest"

  void changeTab(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchFeeds() async {
    try {
      return await _forumController.fetchFeeds(selectedTab.toLowerCase());
    } catch (e) {
      print("Error fetching feeds: $e");
      return [];
    }
  }

  void _navigateToAddPostPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostPage(noIc: widget.user.userIC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: Column(
        children: [
          // Futuristic Tab Bar with gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton("Latest"),
                _buildTabButton("Trending"),
                _buildTabButton("Popular This Week"),
              ],
            ),
          ),
          // Feed Content with futuristic styling
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchFeeds(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No feeds available"));
                } else {
                  final feeds = snapshot.data!;
                  return ListView.builder(
                    itemCount: feeds.length,
                    itemBuilder: (context, index) {
                      final feed = feeds[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedDetailsPage(
                                feedForumID: feed['feedforum_ID'],
                                caption: feed['caption'],
                                creation_dateTime: feed['creation_dateTime'],
                                total_like: feed['total_like'],
                                total_dislikes: feed['total_dislike'],  // Change this to `total_dislikes`
                                user_name: feed['user_name'],
                                images: feed['images'],
                                total_comments: feed['total_comments'],
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                        child: feed['images'].length > 0
                            ? ForumCardWithImage(
                          caption: feed['caption'],
                          imageUrl: feed['images'],
                          comment: feed['total_comments'],
                          likes: feed['total_like'],
                          dislikes: feed['total_dislike'],
                          timeAgo: feed['creation_dateTime'],
                        )
                            : ForumCard(
                          caption: feed['caption'],
                          comment: feed['total_comments'],
                          likes: feed['total_like'],
                          dislikes: feed['total_dislike'],
                          timeAgo: feed['creation_dateTime'],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFloatingActionButton(onPressed: _navigateToAddPostPage),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 3, user: widget.user),
    );
  }

  Widget _buildTabButton(String title) {
    return TextButton(
      onPressed: () => changeTab(title.toLowerCase()),
      child: Text(
        title,
        style: TextStyle(
          color: selectedTab == title.toLowerCase() ? Colors.white : Colors.grey[300],
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

String truncateDescription(String description, int maxLength) {
  return description.length > maxLength ? '${description.substring(0, maxLength)}...' : description;
}

// Animated Floating Action Button
class AnimatedFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AnimatedFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()..scale(1.2),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: "Add Post",
      ),
    );
  }
}

// Forum card without image
class ForumCard extends StatelessWidget {
  final String caption;
  final int comment;
  final int likes;
  final int dislikes;
  final String timeAgo;

  const ForumCard({
    required this.caption,
    required this.comment,
    required this.likes,
    required this.dislikes,
    required this.timeAgo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splitCaption = caption.split(':');
    final String title = splitCaption[0];
    final String description = splitCaption.length > 1 ? truncateDescription(splitCaption[1].trim(), 50) : '';
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text("$comment", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_up, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text("$likes", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_down, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text("$dislikes", style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Text(timeAgo, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Forum card with image
class ForumCardWithImage extends StatelessWidget {
  final String caption;
  final Uint8List imageUrl;
  final int comment;
  final int likes;
  final int dislikes;
  final String timeAgo;

  const ForumCardWithImage({
    required this.caption,
    required this.imageUrl,
    required this.comment,
    required this.likes,
    required this.dislikes,
    required this.timeAgo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splitCaption = caption.split(':');
    final String title = splitCaption[0];
    final String description = splitCaption.length > 1 ? truncateDescription(splitCaption[1].trim(), 50) : '';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.memory(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text("$comment", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_up, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text("$likes", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_down, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text("$dislikes", style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Text(timeAgo, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
