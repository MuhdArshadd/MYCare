import 'package:flutter/material.dart';
import 'package:workshop2dev/view/profilePage.dart';
import '../model/userModel.dart';
import 'homePage.dart';
import 'loginPage.dart';
import 'bottomNavigationBar.dart';
import '../controller/userController.dart';


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
  final UserController _userController = UserController();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      leading: widget.leading ?? IconButton(  // Use the leading widget passed in or default to menu icon
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: () {
          _showSlidingPopupMenu(context, widget.user);
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
  void _showSlidingPopupMenu(BuildContext context, User user) {
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
                    // Center the CircleAvatar
                    Center(
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/myCareWhite.png'),
                        radius: 40,
                        backgroundColor: Colors.blue,  // Change this to any color you prefer
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    // Add Homepage menu item
                    _buildMenuItem(
                      context,
                      icon: Icons.home,
                      label: 'Homepage',
                      onTap: () {
                        // Navigate to your homepage widget
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(user: widget.user)), // Replace with your actual homepage widget
                        );
                      },
                    ),
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
                      icon: Icons.logout,
                      label: 'Log Out',
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () async {
                        Navigator.pop(context); // Close popup
                        await _userController.logout();
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
