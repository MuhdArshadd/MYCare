import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verification Code',
      debugShowCheckedModeBanner: false,
      home: VerificationCodePage(),
    );
  }
}

class VerificationCodePage extends StatefulWidget {
  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  // Controllers for each digit input
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();
  TextEditingController _controller6 = TextEditingController();

  // FocusNodes to control focus for each text field
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  FocusNode _focusNode6 = FocusNode();

  void _resetPassword() {

    String verificationCode =
        _controller1.text + _controller2.text + _controller3.text +
            _controller4.text + _controller5.text + _controller6.text;

    print('Verification code confirmed: $verificationCode');
  }

  // Function to handle focus change when user types a digit
  void _onFieldChanged(String value, FocusNode currentFocus, FocusNode nextFocus) {
    if (value.isNotEmpty) {
      // Move to next field after a digit is entered
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  // Function to handle focus change when user deletes a digit
  void _onFieldDeleted(String value, FocusNode currentFocus, FocusNode previousFocus) {
    if (value.isEmpty) {
      // Move to previous field when backspace is pressed
      FocusScope.of(context).requestFocus(previousFocus);
    }
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
            height: 590.0,
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
          Positioned(
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
          // "Verification Code" Title
          Positioned(
            top: 260.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Instructions Text
          Positioned(
            top: 320.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Enter the verification code we sent to your email...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          // Reset Form and Button
          Positioned(
            top: 400.0,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  // Row of 6 TextFields for the 6 digits
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildVerificationDigitField(_controller1, _focusNode1, _focusNode2),
                        SizedBox(width: 10),
                        buildVerificationDigitField(_controller2, _focusNode2, _focusNode3),
                        SizedBox(width: 10),
                        buildVerificationDigitField(_controller3, _focusNode3, _focusNode4),
                        SizedBox(width: 10),
                        buildVerificationDigitField(_controller4, _focusNode4, _focusNode5),
                        SizedBox(width: 10),
                        buildVerificationDigitField(_controller5, _focusNode5, _focusNode6),
                        SizedBox(width: 10),
                        buildVerificationDigitField(_controller6, _focusNode6, _focusNode6),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.0),
                  ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);  // Action for the Back button
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build each digit input field with automatic focus change
  Widget buildVerificationDigitField(TextEditingController controller, FocusNode currentFocus, FocusNode nextFocus) {
    return SizedBox(
      width: 50.0,
      child: TextField(
        controller: controller,
        focusNode: currentFocus,
        keyboardType: TextInputType.number,
        maxLength: 1, // Limit each field to a single digit
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Only allow digits
        ],
        textAlign: TextAlign.center, // Center the text inside the field
        onChanged: (value) {
          _onFieldChanged(value, currentFocus, nextFocus); // Move to next field after input
          if (value.isEmpty) {
            _onFieldDeleted(value, currentFocus, currentFocus); // Move to previous field if empty (backspace)
          }
        },
        onEditingComplete: () {
          // Move focus to the next field after editing is complete
          FocusScope.of(context).requestFocus(nextFocus);
        },
        decoration: InputDecoration(
          counterText: "", // Hide the counter that shows the number of characters
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
