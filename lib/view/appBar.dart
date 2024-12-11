import 'package:flutter/material.dart';
import 'loginPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('MyCare', style: TextStyle(fontSize: 24, color: Colors.white)),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _showSlidingPopupMenu(context);
          },
        ),
      ],
    );
  }

  /// Function to Show Sliding Popup Menu
  void _showSlidingPopupMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Popup Menu',
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink(); // Placeholder for the page, not used
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.translate(
          offset: Offset(-300 * (1 - anim1.value), 0), // Slide from left
          child: Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              elevation: 4,
              child: Container(
                width: 250,
                height: MediaQuery.of(context).size.height, // Adjust height dynamically
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50), // Space for design
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/myCare.png'),
                      radius: 40,
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    _buildMenuItem(
                      context,
                      icon: Icons.person,
                      label: 'My Profile',
                      onTap: () {
                        Navigator.pop(context); // Close popup
                        print('My Profile selected');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () {
                        Navigator.pop(context); // Close popup
                        print('Settings selected');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.email,
                      label: 'Email',
                      onTap: () {
                        Navigator.pop(context); // Close popup
                        print('Email selected');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.help,
                      label: 'Help & Support',
                      onTap: () {
                        Navigator.pop(context); // Close popup
                        print('Help & Support selected');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.logout,
                      label: 'Log Out',
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () {
                        Navigator.pop(context); // Close popup
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Helper Widget to Build Menu Items
  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
        Color iconColor = Colors.blue,
        Color textColor = Colors.black,
      }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label, style: TextStyle(color: textColor)),
      onTap: onTap,
    );
  }
}
