import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '../model/userModel.dart';
import 'loginPage.dart';
import 'homePage.dart';
import '../controller/userController.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await _userController.isLoggedIn();
    print('Is user logged in? $isLoggedIn'); // Debug log

    if (isLoggedIn ) {
      // User is logged in, retrieve user details
      User? user = await _userController.getLoggedInUser();
      print('Retrieved user: $user'); // Debug log

      // Navigate to HomePage with the User object
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      } else {
        print('User details could not be retrieved'); // Debug log
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } else {
      print('User is not logged in, navigating to LoginPage'); // Debug log
      // User is not logged in, navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue, // Set background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/myCareWhite.png', // Path to your splash screen image
                width: 200.0, // Set the size of the splash image
                height: 200.0,
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

}
