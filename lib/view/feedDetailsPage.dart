import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../controller/forumController.dart';
import '../model/userModel.dart';

class FeedDetailsPage extends StatefulWidget {
  final String feedForumID;
  final String caption;
  final String creation_dateTime;
  final int total_like;
  final int total_dislikes;
  final String user_name;
  final Uint8List? images; // Nullable to handle feeds without images
  final int total_comments;
  final User user;

  const FeedDetailsPage({
    super.key,
    required this.feedForumID,
    required this.user,
    required this.caption,
    required this.creation_dateTime,
    required this.total_like,
    required this.total_dislikes,
    required this.user_name,
    this.images, // Nullable images
    required this.total_comments,
  });

  @override
  _FeedDetailsPageState createState() => _FeedDetailsPageState();
}

class _FeedDetailsPageState extends State<FeedDetailsPage> {
  final ForumController forumController = ForumController();
  late Future<List<Map<String, dynamic>>> _commentsFuture;
  final TextEditingController _commentController = TextEditingController();

  int totalLikes = 0;
  int totalDislikes = 0;
  int? userSelection; // 1 for like, 2 for dislike, null for no selection

  @override
  void initState() {
    super.initState();
    _commentsFuture = forumController.fetchFeedComments(widget.feedForumID);
    totalLikes = widget.total_like;
    totalDislikes = widget.total_dislikes;
  }

  Future<void> _updateLikes(int selection) async {
    // Prevent the user from spamming the same choice
    if (userSelection == selection) return;

    try {
      final response = await forumController.updateFeedLikes(selection, widget.feedForumID, widget.user.userIC);
      setState(() {
        if (selection == 1) {
          // Increment likes, decrement dislikes if previously selected
          totalLikes++;
          if (userSelection == 2) totalDislikes--;
        } else if (selection == 2) {
          // Increment dislikes, decrement likes if previously selected
          totalDislikes++;
          if (userSelection == 1) totalLikes--;
        }
        userSelection = selection; // Update user selection
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating likes: $e")),
      );
    }
  }

  void _submitComment() async {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      try {
        await forumController.commentFeed(widget.feedForumID, widget.user.userIC, comment);
        setState(() {
          _commentsFuture = forumController.fetchFeedComments(widget.feedForumID);
        });
        _commentController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add comment: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment cannot be empty")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed Details"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feed details section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.caption,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Posted by: ${widget.user_name} on ${widget.creation_dateTime}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  widget.images != null && widget.images!.isNotEmpty
                      ? Image.memory(
                    widget.images!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : const Text(
                    "",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Likes Button
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateLikes(1),
                            icon: Icon(
                              userSelection == 1
                                  ? Icons.thumb_up_alt
                                  : Icons.thumb_up_alt_outlined,
                            ),
                            color: Colors.blue,
                          ),
                          Text(
                            "$totalLikes",
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      // Dislikes Button
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateLikes(2),
                            icon: Icon(
                              userSelection == 2
                                  ? Icons.thumb_down_alt
                                  : Icons.thumb_down_alt_outlined,
                            ),
                            color: Colors.red,
                          ),
                          Text(
                            "$totalDislikes",
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Total Comments: ${widget.total_comments}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Comments section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error fetching comments: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No comments available"));
                  } else {
                    final comments = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              comment['comment_author'][0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(comment['comment']),
                          subtitle: Text(
                              "By ${comment['comment_author']} on ${comment['comment_dateTime']}"),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const Divider(),

            // Comment input section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: "Enter your comment",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitComment,
                    child: const Text("Post"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
