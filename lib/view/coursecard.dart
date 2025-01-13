import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final String title;
  final String level;
  final String duration;
  final String? imageUrl;
  final VoidCallback onTap;

  const CourseCard({
    required this.title,
    required this.level,
    required this.duration,
    this.imageUrl,
    required this.onTap,
  });

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isFavorited = false; // State to track if the course is favorited

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          leading: widget.imageUrl != null
              ? Image.network(widget.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
              : Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
          title: Text(widget.title),
          subtitle: Text("Level: ${widget.level}\nDuration: ${widget.duration}"),
          trailing: IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isFavorited = !isFavorited; // Toggle favorite state
              });
            },
          ),
        ),
      ),
    );
  }
}
