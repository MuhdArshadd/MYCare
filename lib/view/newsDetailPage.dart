import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'chatbotAI.dart';
import 'newsPage.dart'; // Import the NewsPage for navigation

class NewsDetailPage extends StatefulWidget {
  final User user;
  final Map<String, dynamic> article;

  const NewsDetailPage({super.key, required this.article, required this.user});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button Below the AppBar
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsPage(user: widget.user),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Display image based on its type (Uint8List or URL)
              widget.article['image_url'] != null
                  ? widget.article['image_url'] is Uint8List
                  ? Image.memory(
                widget.article['image_url'], // Display the image from Uint8List
                fit: BoxFit.contain, // Maintain the image's aspect ratio
              )
                  : Image.network(
                widget.article['image_url'], // Display the image from the URL
                fit: BoxFit.cover, // Cover the available space
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              )
                  : Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.article['title'] ?? 'No Title',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'By ${widget.article['author'] ?? 'Unknown'} | ${widget.article['date'] ?? 'Unknown Date'}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                widget.article['description'] ?? 'No Description Available',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
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
      bottomNavigationBar: BottomNavWrapper(
        currentIndex: 1,
        user: widget.user,
      ),
    );
  }
}
