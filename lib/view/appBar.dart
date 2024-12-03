import 'package:flutter/material.dart';
import 'loginPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [
          Text('MyCare', style: TextStyle(fontSize: 24, color: Colors.white)),
        ],
      ),
      backgroundColor: Colors.blue,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white),
          onSelected: (value) {
            if (value == 'Notifications') {
              print('Notifications selected');
            } else if (value == 'Settings') {
              print('Settings selected');
            } else if (value == 'Help') {
              print('Help selected');
            } else if (value == 'Logout') {
              // Navigate to Login Page on Logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          },
          offset: const Offset(-100, 50),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Notifications',
              child: Row(
                children: [
                  Icon(Icons.notifications, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Notifications'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Settings',
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Help',
              child: Row(
                children: [
                  Icon(Icons.help, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Help'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
