import 'package:flutter/material.dart';
import 'package:workshop2dev/view/loginPage.dart'; // Import login page
import 'package:workshop2dev/view/SignInPage.dart'; // Import sign-up page
import 'package:workshop2dev/view/homePage.dart';  // Import home page after successful login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Energy Monitoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInPage(), // Start with the Sign Up page
      routes: {
        '/login': (context) => LoginPage(), // Route to login page
        '/home': (context) => HomePage(),   // Route to home page after successful login
      },
    );
  }
}
