import 'package:flutter/material.dart';
import 'package:workshop2dev/view/profilePage.dart';
import '../model/userModel.dart';
import 'loginPage.dart';
import 'bottomNavigationBar.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final User user;
  final Widget? leading; // Add the optional leading widget

  const CustomAppBar({super.key, required this.user, this.leading}); // Modify the constructor to accept leading

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      leading: widget.leading ?? IconButton(  // Use the leading widget passed in or default to menu icon
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: () {
          _showSlidingPopupMenu(context);
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5), // Space between the icon and text
          const Text(
            'MyCare',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold, // Bold text
              color: Colors.white,
            ),
          ),
        ],
      ),
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
            alignment: Alignment.centerLeft, // Align to the left
            child: Material(
              color: Colors.transparent,
              elevation: 4,
              child: Container(
                width: 250,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user)));
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
      leading: Icon(icon, color: iconColor, size: 24), // Standard size for icons
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold, // Bold text for menu items
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
