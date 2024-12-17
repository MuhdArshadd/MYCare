import 'package:flutter/material.dart';
import 'package:workshop2dev/view/verificationCodePage.dart';
import 'signUpPage.dart';
import 'loginPage.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();

  void _resetPassword() {
    final email = _emailController.text;
    final newPass = _newPassController.text;

    // Check if the email field is empty
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email address')),
      );
      return;
    }

    // Simulate password reset logic and display a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset email sent to $email')),
    );

    // Navigate to the verification code page after resetting
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationCodePage(
          email: email,       // Pass the email
          newPass: newPass,   // Pass the new password
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 590.0, // Set custom height for the background image
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Logo or title image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250.0,
            child: Image.asset(
              'assets/myCareWhite.png',
            ),
          ),
          // "My Care" Title
          const Positioned(
            top: 200.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'My Care',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Reset Form
          Positioned(
            top: 290.0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    // Email Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Email Field
                    TextField(
                      controller: _newPassController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'New Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100.0),
                    // Send Code Button
                    ElevatedButton(
                      onPressed: _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Send Code',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
          // Information Text
          Positioned(
            top: 550.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Code will be sent to the provided email.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
