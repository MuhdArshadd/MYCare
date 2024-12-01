import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text('MyCare', style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
      backgroundColor: Colors.blue,
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: Colors.white),
          onSelected: (value) {
            if (value == 'Notifications') {
              print('Notifications selected');
            } else if (value == 'Settings') {
              print('Settings selected');
            } else if (value == 'Help') {
              print('Help selected');
            }
          },
          offset: Offset(-100, 50),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Notifications',
              child: Row(
                children: [
                  Icon(Icons.notifications, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Notifications'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'Settings',
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Settings'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'Help',
              child: Row(
                children: [
                  Icon(Icons.help, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Help'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
