import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// Import your home page
import 'loginPage.dart';

class MySplashScreen extends StatelessWidget {
  const MySplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: 'assets/myCareWhite.png', // Path to your splash screen image
      nextScreen: const LoginPage(), // Navigate to home page after splash screen
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.blue,
      splashIconSize: 200.0, // Set the size of the splash image
    );
  }
}