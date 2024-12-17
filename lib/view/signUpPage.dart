import 'package:flutter/material.dart';
import 'package:workshop2dev/controller/userController.dart';
import 'package:workshop2dev/view/loginPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _noIcController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _nophoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final UserController _userController = UserController();

  bool _acceptTerm = false;
  String? _selectedPosition;
  String? _selectedIncomeRange;
  String? _selectedMarriedStatus;

  // Function to Register
  void _signUp() async {
    final noIc = _noIcController.text;
    final fullname = _fullnameController.text;
    final age = _ageController.text;
    final email = _emailController.text;
    final phoneNumber = _nophoneController.text;
    final address = _addressController.text;
    final userCategory = _selectedPosition ?? '';
    final incomeRange = _selectedIncomeRange ?? '';
    final marriageStatus = _selectedMarriedStatus ?? '';
    final password = _passwordController.text;
    final confirmPass = _confirmpasswordController.text;

    if (noIc.isEmpty || fullname.isEmpty || age.isEmpty || email.isEmpty ||
        phoneNumber.isEmpty || address.isEmpty || userCategory.isEmpty ||
        incomeRange.isEmpty || marriageStatus.isEmpty || password.isEmpty ||
        confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    String response = await _userController.signUp(noIc, fullname, age, email, phoneNumber, address, userCategory, incomeRange, marriageStatus, password);

    if (response == "Sign up successful") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign Up Successful'),
            content: const Text('You have successfully signed up!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // Navigate after closing the dialog
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up failed: $response')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 500.0, bottom: 200.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 610.0, // Set custom height for the background image
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),

            // Sign Up Form Fields
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250.0, // Set custom height for the background image
            child: Image.asset(
              'assets/myCareWhite.png',
            ),
          ),
          const Positioned(
            top: 200.0, // Adjust vertical position to avoid overlap with logo
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'My Care',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Adjust color if needed
                ),
              ),
            ),
          ),
          // Content slightly below the top
          Positioned(
            top: 270.0, // Adjust vertical position to avoid overlap with the logo
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Back Button at the top

                    // Sign Up Form Fields
                    TextField(
                      controller: _noIcController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.card_membership),
                        hintText: 'No IC ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _fullnameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Fullname ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.confirmation_number),
                        hintText: 'Age ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                    TextField(
                      controller: _nophoneController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: 'No.Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.home),
                        hintText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      value: _selectedPosition,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category),
                        hintText: 'Select Position',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Student', child: Text('Student')),
                        DropdownMenuItem(value: 'Employee', child: Text('Employee')),
                        DropdownMenuItem(value: 'Self-employed', child: Text('Self-employed')),
                        DropdownMenuItem(value: 'Unemployed', child: Text('Unemployed')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPosition = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      value: _selectedIncomeRange,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.money),
                        hintText: 'Select Salary ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'RM0-RM1500', child: Text('RM0-RM1500')),
                        DropdownMenuItem(value: 'RM1500-RM3000', child: Text('RM1500-RM3000')),
                        DropdownMenuItem(value: 'RM3000-RM5000', child: Text('RM3000-RM5000')),
                        DropdownMenuItem(value: '>RM5000', child: Text('>RM5000')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedIncomeRange = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      value: _selectedMarriedStatus,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.manage_accounts_rounded),
                        hintText: 'Marital Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Single', child: Text('Single')),
                        DropdownMenuItem(value: 'Married', child: Text('Married')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedMarriedStatus = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 17.0,
                          ),
                          children: const [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}