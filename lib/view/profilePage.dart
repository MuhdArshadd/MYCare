import 'package:flutter/material.dart';
import '../model/userModel.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';
import 'package:workshop2dev/controller/userController.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, bool> editMode = {}; // Tracks editing state for each field
  Map<String, TextEditingController> controllers = {}; // Field-specific controllers

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centering the content
          children: [
            // Centering the "My Profile" text
            Center(
              child: Text(
                "My Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            // Profile Icon (medium size)
            Icon(
              Icons.person, // Default profile icon
              size: 80, // Medium size
              color: Colors.grey[800], // Icon color
            ),
            SizedBox(height: 32), // Space between the icon and the profile fields
            _buildEditableField("Full Name", Icons.account_circle),
            _buildEditableField("Age", Icons.confirmation_num),
            _buildEditableField("Email", Icons.email),
            _buildEditableField("Phone", Icons.phone),
            _buildEditableField("Address", Icons.home),
            _buildEditableField("Category", Icons.category),
            _buildEditableField("Income Range", Icons.money),
            _buildEditableField("Marriage Status", Icons.manage_accounts_rounded),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey),
                SizedBox(width: 16),
                Expanded(
                  child: editMode[label]!
                      ? label == "Income Range" || label == "Category" || label == "Marriage Status"
                      ? _buildDropdownField(label)  // Show dropdown for specific fields
                      : TextField(
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
                      SizedBox(height: 4),
                      Text(controllers[label]!.text,
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (editMode[label]!) {
                        // Save changes
                        _saveChanges(label);
                      }
                      // Toggle edit mode
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
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    List<DropdownMenuItem<String>> items = [];
    if (label == "Income Range") {
      items = [
        DropdownMenuItem(value: 'RM0-RM1500', child: Text('RM0-RM1500')),
        DropdownMenuItem(value: 'RM1500-RM3000', child: Text('RM1500-RM3000')),
        DropdownMenuItem(value: 'RM3000-RM5000', child: Text('RM3000-RM5000')),
        DropdownMenuItem(value: '>RM5000', child: Text('>RM5000')),
      ];
    } else if (label == "Category") {
      items = [
        DropdownMenuItem(value: 'Student', child: Text('Student')),
        DropdownMenuItem(value: 'Employee', child: Text('Employee')),
        DropdownMenuItem(value: 'Self-employed', child: Text('Self-employed')),
        DropdownMenuItem(value: 'Unemployed', child: Text('Unemployed')),
        DropdownMenuItem(value: 'Other', child: Text('Other')),
      ];
    } else if (label == "Marriage Status") {
      items = [
        DropdownMenuItem(value: 'Single', child: Text('Single')),
        DropdownMenuItem(value: 'Married', child: Text('Married')),
      ];
    }

    return DropdownButton<String>(
      value: controllers[label]!.text.isEmpty ? null : controllers[label]!.text,
      isExpanded: true,
      items: items,
      onChanged: (String? newValue) {
        setState(() {
          controllers[label]!.text = newValue!;
        });
      },
      hint: Text('Select $label'),
    );
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
}
