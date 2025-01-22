import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../controller/forumController.dart';
import '../model/userModel.dart';
import 'forumPage.dart';
import 'appBar.dart';

class FeedDetailsPage extends StatefulWidget {
  final String feedForumID;
  final String caption;
  final String creation_dateTime;
  final int total_like;
  final int total_dislikes;
  final String user_name;
  final Uint8List? images;
  final Uint8List? profileImage; // Nullable to handle feeds without images
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
    this.images,
    this.profileImage,// Nullable images
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
  int totalComments = 0;

  @override
  void initState() {
    super.initState();
    _commentsFuture = forumController.fetchFeedComments(widget.feedForumID);
    totalLikes = widget.total_like;
    totalDislikes = widget.total_dislikes;
    totalComments = widget.total_comments;
  }

  Future<void> _updateLikes(int selection) async {
    if (userSelection != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "You have already ${userSelection == 1 ? 'liked' : 'disliked'} this post"),
        ),
      );
      return;
    }

    try {
      final response = await forumController.updateFeedLikes(
        selection,
        widget.feedForumID,
        widget.user.userIC,
      );

      if (response == "Action not allowed") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You can only like or dislike once")),
        );
        return;
      }

      setState(() {
        if (selection == 1) {
          totalLikes++;
        } else if (selection == 2) {
          totalDislikes++;
        }
        userSelection = selection;
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
        await forumController.commentFeed(
          widget.feedForumID,
          widget.user.userIC,
          comment,
        );
        setState(() {
          _commentsFuture = forumController.fetchFeedComments(widget.feedForumID);
          totalComments += 1;
        });
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Comment added successfully")),
        );
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForumPage(user: widget.user),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: theme.primaryColor,
                    child: widget.profileImage == null || widget.profileImage!.isEmpty
                        ? const Text(
                      'L',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,  // Adjust the size as necessary
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : ClipOval(
                      child: Image.memory(
                        widget.profileImage!,
                        fit: BoxFit.cover,  // Ensures the image fits within the circle
                        width: 60,  // Adjust the width and height to match the CircleAvatar radius
                        height: 60,
                      ),
                    ),
                  ),


                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user_name,
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Posted on: ${widget.creation_dateTime}",
                          style: theme.textTheme.bodyMedium,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.images != null && widget.images!.isNotEmpty)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.memory(
                              widget.images!,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Chip(
                              backgroundColor: Colors.black54,
                              label: Text(
                                widget.creation_dateTime,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.caption,
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ActionChip(
                                avatar: Icon(
                                  Icons.thumb_up,
                                  color: userSelection == 1
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                label: Text(
                                  "$totalLikes",
                                  style: TextStyle(
                                    color: userSelection == 1
                                        ? Colors.blue
                                        : Colors.black,
                                    fontWeight: userSelection == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                onPressed: () => _updateLikes(1),
                                backgroundColor: userSelection == 1
                                    ? Colors.blue[50]
                                    : Colors.grey[200],
                              ),
                              const SizedBox(width: 10),
                              ActionChip(
                                avatar: Icon(
                                  Icons.thumb_down,
                                  color: userSelection == 2
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                label: Text(
                                  "$totalDislikes",
                                  style: TextStyle(
                                    color: userSelection == 2
                                        ? Colors.red
                                        : Colors.black,
                                    fontWeight: userSelection == 2
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                onPressed: () => _updateLikes(2),
                                backgroundColor: userSelection == 2
                                    ? Colors.red[50]
                                    : Colors.grey[200],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Comment"));
                  }

                  final comments = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border:
                            Border.all(color: Colors.grey[400]!, width: 1),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: theme.primaryColor,
                                child: comment['comment_profile'] == null || (comment['comment_profile'] as Uint8List).isEmpty
                                    ? const Text(
                                  'P',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,  // Adjust the size as necessary
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : ClipOval(
                                  child: Image.memory(
                                    comment['comment_profile'],
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),


                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment['comment'],
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "By ${comment['comment_author']} on ${comment['comment_dateTime']}",
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitComment,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
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
