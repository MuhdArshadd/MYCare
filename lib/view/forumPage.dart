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
  Future<List<Map<String, dynamic>>>? _feedFuture;

  void changeTab(String tab) {
    setState(() {
      selectedTab = tab;
      _feedFuture = _fetchFeeds(); // Fetch feeds for the selected tab
    });
  }

  Future<List<Map<String, dynamic>>> _fetchFeeds() async {
    try {
      return await _forumController.fetchFeeds(selectedTab.toLowerCase());
    } catch (e) {
      print("Error fetching feeds: $e");
      throw e; // Throw error to be caught in the FutureBuilder
    }
  }

  Future<void> _deletePost(String feedForumID) async {
    try {
      final result = await _forumController.deletePost(feedForumID, widget.user.userIC);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      setState(() {
        _feedFuture = _fetchFeeds(); // Refresh the feed list after deletion
      });
    } catch (e) {
      print("Error deleting post: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting post: $e")),
      );
    }
  }

  void _navigateToAddPostPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostPage(noIc: widget.user.userIC, user: widget.user),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _feedFuture = _fetchFeeds(); // Initialize feed fetching
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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
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
              future: _feedFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No feeds available"));
                } else {
                  final feeds = snapshot.data!;
                  return ListView.builder(
                    itemCount: feeds.length,
                    itemBuilder: (context, index) {
                      final feed = feeds[index];
                      final bool isUserPost = feed['user_name'] == widget.user.fullname;

                      return GestureDetector(
                        onLongPressStart: (details) {
                          if (isUserPost) {
                            Future.delayed(const Duration(seconds: 1), () {
                              _showDeleteConfirmationDialog(feed['feedforum_ID']);
                            });
                          }
                        },
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedDetailsPage(
                                feedForumID: feed['feedforum_ID'],
                                caption: feed['caption'],
                                creation_dateTime: feed['creation_dateTime'],
                                total_like: feed['total_like'],
                                total_dislikes: feed['total_dislike'],
                                user_name: feed['user_name'],
                                images: feed['images'],
                                total_comments: feed['total_comments'],
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                        child: _buildFeedCard(feed, isUserPost),
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

  Widget _buildFeedCard(Map<String, dynamic> feed, bool isUserPost) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isUserPost ? BorderSide(color: Colors.blueAccent, width: 2) : BorderSide.none,
      ),
      color: isUserPost ? Colors.white : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(feed['caption']),
            subtitle: Text("Posted by ${feed['user_name']}"),
          ),
          if (feed['images'] is Uint8List && feed['images'].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(
                feed['images'],
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
                    Text("${feed['total_comments']}", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_up, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text("${feed['total_like']}", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Icon(Icons.thumb_down, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text("${feed['total_dislike']}", style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Text(feed['creation_dateTime'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(String feedForumID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Post"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deletePost(feedForumID); // Call the delete function
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error: $error"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _feedFuture = _fetchFeeds(); // Retry fetching data
              });
            },
            child: const Text("Retry"),
          ),
        ],
      ),
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

// Define the AnimatedFloatingActionButton here
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
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
