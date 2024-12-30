import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Add file_picker package
import 'package:workshop2dev/controller/forumController.dart';

class AddPostPage extends StatefulWidget {
  final String noIc;

  const AddPostPage({super.key, required this.noIc});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final ForumController forumController = ForumController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? imageBytes;
  String status = "";
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Pick image from the file system
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        final File file = File(filePath);
        final Uint8List imageBytess = await file.readAsBytes();
        setState(() {
          imageBytes = imageBytess;
        });
      }
    } else {
      setState(() {
        status = "No image selected.";
      });
    }
  }

// Function to submit the post with title and description combined into a caption
  Future<void> _submitPost() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String caption = "$title: $description"; // Combine title and description

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Description cannot be empty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String result = await forumController.postFeed(widget.noIc, caption, imageBytes);

      setState(() {
        status = result;
        _isLoading = false;
      });

      if (result == "Post successful") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post submitted successfully!')),
        );
        Navigator.pop(context); // Navigate back after submission
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $result')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            ),
            const SizedBox(width: 10),
            const Text(
              "MyCare",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: Drawer(
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
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView
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
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            // Image Picker Section
            imageBytes == null
                ? GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo, size: 40),
                    const SizedBox(height: 10),
                    const Text(
                      "Tap here to select a photo",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Or, you can skip this step",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            )
                : Image.memory(imageBytes!, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            // Status Text for Image Upload/Download
            Text(
              status,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 20),
            // Submit Button
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _submitPost,
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
