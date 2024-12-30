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

  // Function to change tab and trigger fetching new data
  void changeTab(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchFeeds() async {
    try {
      // Replace with the actual call to fetch data based on selected tab
      return await _forumController.fetchFeeds(selectedTab.toLowerCase());
    } catch (e) {
      print("Error fetching feeds: $e");
      return []; // Return an empty list in case of an error
    }
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
      appBar: CustomAppBar(user: widget.user),
      body: Column(
        children: [
          // Tabs for selecting feed types
          Container(
            color: Colors.lightBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => changeTab("latest"),
                  child: Text(
                    "Latest",
                    style: TextStyle(
                      color: selectedTab == "latest" ? Colors.white : Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => changeTab("trending"),
                  child: Text(
                    "Trending",
                    style: TextStyle(
                      color: selectedTab == "trending" ? Colors.white : Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => changeTab("popular this week"),
                  child: Text(
                    "Popular This Week",
                    style: TextStyle(
                      color: selectedTab == "popular this week" ? Colors.white : Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Feed Content with FutureBuilder
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchFeeds(), // Asynchronous call to fetch data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show loading
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}")); // Show error message
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No feeds available")); // Show empty state message
                } else {
                  final feeds = snapshot.data!;
                  return ListView.builder(
                    itemCount: feeds.length,
                    itemBuilder: (context, index) {
                      final feed = feeds[index];
                      // Return a clickable card based on feed data
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedDetailsPage(feedForumID: feed['feedforum_ID'], caption: feed['caption'], creation_dateTime: feed['creation_dateTime'] , total_like: feed['total_like'], total_dislikes: feed['total_dislike'], user_name: feed['user_name'], images: feed['images'], total_comments: feed['total_comments'] , user: widget.user),  // Navigate on tap
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

String truncateDescription(String description, int maxLength) {
  return description.length > maxLength ? '${description.substring(0, maxLength)}...' : description;
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              caption,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text("$comment", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text("$likes", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_down, size: 16, color: Colors.grey),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    caption,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text("$comment", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text("$likes", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_down, size: 16, color: Colors.grey),
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
