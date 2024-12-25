import 'package:flutter/material.dart';
import 'appbar.dart'; // Import your custom AppBar

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // Simulated user data
  Map<String, String> userInfo = {
    'fullname': 'Alya',
    'age': '26',
    'email': 'alya@gmail.com',
    'phone': '123-456-7890',
    'address': '123 Main Street',
    'position': 'Employed',
    'income': '1500-3000',
    'marital': 'Single',
  };

  // Track editing states for editable fields
  Map<String, bool> isEditing = {
    'email': false,
    'phone': false,
    'address': false,
    'position': false,
    'income': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed the default AppBar, using only CustomAppBar
      appBar: CustomAppBar(), // Custom app bar is used here only
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'MyCare',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'My Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display all fields, making only specific ones editable
            ...userInfo.entries.map((entry) {
              String key = entry.key;
              String value = entry.value;

              // Only editable for specified keys
              bool editable = isEditing.containsKey(key);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: value,
                        enabled: editable && (isEditing[key] ?? false),
                        decoration: InputDecoration(
                          labelText: _capitalize(key),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (newValue) {
                          if (editable) {
                            setState(() {
                              userInfo[key] = newValue;
                            });
                          }
                        },
                      ),
                    ),
                    if (editable) // Only show edit/check icon for editable fields
                      const SizedBox(width: 10),
                    if (editable)
                      IconButton(
                        icon: Icon(
                          isEditing[key] == true ? Icons.check : Icons.edit,
                          color: isEditing[key] == true ? Colors.green : Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            isEditing[key] = !(isEditing[key] ?? false); // Toggle edit mode
                          });
                        },
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
}
