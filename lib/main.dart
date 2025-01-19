import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Import dotenv package
import 'package:workshop2dev/view/splash_screen.dart';  // Import home page after successful login

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MySplashScreen(), // Start with the splash screen
    );
  }
}
