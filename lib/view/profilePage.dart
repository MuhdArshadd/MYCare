import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:workshop2dev/controller/userController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import '../model/userModel.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, bool> editMode = {}; // Tracks editing state for each field
  Map<String, TextEditingController> controllers = {}; // Field-specific controllers
  Uint8List? imageBytes; // Holds the image data
  String status = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize all fields as non-editable and set up controllers
    editMode = {
      "Full Name": false,
      "Age": false,
      "Email": false,
      "Phone": false,
      "Address": false,
      "Category": false,
      "Income Range": false,
      "Marriage Status": false,
    };

    controllers = {
      "Full Name": TextEditingController(text: widget.user.fullname),
      "Age": TextEditingController(text: widget.user.age.toString()),
      "Email": TextEditingController(text: widget.user.email),
      "Phone": TextEditingController(text: widget.user.phoneNumber),
      "Address": TextEditingController(text: widget.user.address),
      "Category": TextEditingController(text: widget.user.userCategory),
      "Income Range": TextEditingController(text: widget.user.incomeRange),
      "Marriage Status": TextEditingController(text: widget.user.marriageStatus),
    };
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null && result.files.single.path != null) {
      final File file = File(result.files.single.path!);
      final Uint8List imageBytess = await file.readAsBytes();
      setState(() {
        imageBytes = compressImage(imageBytess);
        widget.user.profileImage = imageBytes;
        status = "Image selected.";
      });

      // Insert the image into the database
      await _saveProfileImage();
    } else {
      setState(() {
        status = "No image selected.";
      });
    }
  }

  // Image compression function
  Uint8List compressImage(Uint8List imageData) {
    img.Image? originalImage = img.decodeImage(imageData);
    img.Image resizedImage = img.copyResize(originalImage!, width: 200);
    return Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
  }

  Future<void> _saveChanges(String label) async {
    setState(() {
      switch (label) {
        case "Full Name":
          widget.user.fullname = controllers[label]!.text;
          break;
        case "Age":
          widget.user.age = int.tryParse(controllers[label]!.text) ?? widget.user.age;
          break;
        case "Email":
          widget.user.email = controllers[label]!.text;
          break;
        case "Phone":
          widget.user.phoneNumber = controllers[label]!.text;
          break;
        case "Address":
          widget.user.address = controllers[label]!.text;
          break;
        case "Category":
          widget.user.userCategory = controllers[label]!.text;
          break;
        case "Income Range":
          widget.user.incomeRange = controllers[label]!.text;
          break;
        case "Marriage Status":
          widget.user.marriageStatus = controllers[label]!.text;
          break;
      }
    });

    String response = await UserController().updateUser(widget.user);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
  }

  Future<void> _saveProfileImage() async {
    if (imageBytes != null) {
      try {
        String response = await UserController().insertOrUpdateProfile(widget.user.userIC, imageBytes);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to upload image: $e")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No image selected.")));
    }
  }


  Future<void> _saveAllChanges() async {
    setState(() => _isLoading = true);
    await Future.wait(editMode.keys.map((field) => _saveChanges(field)));
    await _saveProfileImage();  // Save the image if selected
    setState(() {
      _isLoading = false;
      editMode.updateAll((key, value) => false); // Disable all edit modes
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully.")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centering the content
          children: [
            Center(
              child: Text(
                "My Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            // Profile Image Section
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.user.profileImage != null
                      ? MemoryImage(widget.user.profileImage!) // Display the selected image
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                      // Default image
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.blue),
                    onPressed: _pickImage, // Trigger image picker
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(status, style: TextStyle(color: Colors.red)),
            const SizedBox(height: 32), // Space between the image and fields
            _buildEditableField("Full Name", Icons.account_circle),
            _buildEditableField("Age", Icons.confirmation_num),
            _buildEditableField("Email", Icons.email),
            _buildEditableField("Phone", Icons.phone),
            _buildEditableField("Address", Icons.home),
            _buildEditableField("Category", Icons.category),
            _buildEditableField("Income Range", Icons.money),
            _buildEditableField("Marriage Status", Icons.manage_accounts_rounded),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveAllChanges,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Save Profile"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),
        ],
        currentIndex: 3, // Highlights the "Profile" icon
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildEditableField(String label, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: editMode[label]!
                  ? TextField(
                controller: controllers[label],
                decoration: InputDecoration(
                  labelText: label,
                  border: UnderlineInputBorder(),
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    controllers[label]!.text,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (editMode[label]!) {
                    _saveChanges(label);
                  }
                  editMode[label] = !editMode[label]!;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: editMode[label]! ? Colors.green : Colors.blue,
                minimumSize: Size(60, 36),
              ),
              child: Text(editMode[label]! ? "Save" : "Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
