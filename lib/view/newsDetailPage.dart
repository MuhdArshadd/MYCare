import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart'; // Import the BottomNavWrapper widget

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
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(  // Make the entire body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display image with its original size if available
              widget.article['images'] != null && widget.article['images'] is Uint8List
                  ? Image.memory(
                widget.article['images'], // Display the image from Uint8List
                fit: BoxFit.contain, // Use BoxFit.contain to maintain the image's aspect ratio
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
                widget.article['headline'],
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'By ${widget.article['author']} | ${widget.article['date']}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                widget.article['description'], // Display the description
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 1, user: widget.user), // Add the bottom navigation bar here
    );
  }
}
//s