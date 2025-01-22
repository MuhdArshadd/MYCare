import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:workshop2dev/controller/userController.dart';
import 'package:workshop2dev/view/loginPage.dart';
import 'dart:io'; // For File type
import 'package:file_picker/file_picker.dart';

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

  String? _selectedPosition;
  String? _selectedIncomeRange;
  String? _selectedMarriedStatus;
  Uint8List? imageBytes;
  String status = "";

  // Error handling flags
  String? noIcError, fullnameError, ageError, emailError, phoneError, addressError, positionError, incomeRangeError, maritalStatusError, passwordError, confirmPasswordError;

  // Pick image from the file system
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        final File file = File(filePath);
        final Uint8List imageBytess = await file.readAsBytes();
        setState(() {
          imageBytes = imageBytess;
        });
      }
    } else {
      setState(() {
        status = "No image selected.";
      });
    }
  }

  // Function to Register
  void _signUp() async {
    // Clear previous errors
    setState(() {
      noIcError = fullnameError = ageError = emailError = phoneError = addressError = positionError = incomeRangeError = maritalStatusError = passwordError = confirmPasswordError = null;
    });

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

    bool isValid = true;

    // Validate inputs
    if (noIc.isEmpty) {
      setState(() {
        noIcError = "IC number is required.";
      });
      isValid = false;
    }
    if (fullname.isEmpty) {
      setState(() {
        fullnameError = "Full name is required.";
      });
      isValid = false;
    }
    if (age.isEmpty || int.tryParse(age) == null) {
      setState(() {
        ageError = "Valid age is required.";
      });
      isValid = false;
    }
    if (email.isEmpty || !RegExp(r"^[a-zA-Z0-9]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$").hasMatch(email)) {
      setState(() {
        emailError = "Valid email is required.";
      });
      isValid = false;
    }
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      setState(() {
        phoneError = "Valid phone number is required.";
      });
      isValid = false;
    }
    if (address.isEmpty) {
      setState(() {
        addressError = "Address is required.";
      });
      isValid = false;
    }
    if (userCategory.isEmpty) {
      setState(() {
        positionError = "Position is required.";
      });
      isValid = false;
    }
    if (incomeRange.isEmpty) {
      setState(() {
        incomeRangeError = "Income range is required.";
      });
      isValid = false;
    }
    if (marriageStatus.isEmpty) {
      setState(() {
        maritalStatusError = "Marital status is required.";
      });
      isValid = false;
    }
    if (password.isEmpty) {
      setState(() {
        passwordError = "Password is required.";
      });
      isValid = false;
    }
    if (confirmPass != password) {
      setState(() {
        confirmPasswordError = "Passwords do not match.";
      });
      isValid = false;
    }

    if (!isValid) {
      return; // Exit if any validation fails
    }

    String response = await _userController.signUp(noIc, fullname, age, email, phoneNumber, address, userCategory, incomeRange, marriageStatus, password, imageBytes);

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
            top: 50.0, // Adjust vertical position
            left: 0,
            right: 0,
            height: 250.0, // Set custom height for the section
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes!) // Display the selected image
                          : AssetImage('assets/myCareWhite.png') as ImageProvider,
                      // Default image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                          size: 36.0, // Adjust size as needed
                        ),
                        onPressed: _pickImage, // Trigger image picker
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                const Text(
                  'Upload Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
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
                    // Sign Up Form Fields
                    _buildTextField(_noIcController, 'No IC', Icons.card_membership, noIcError),
                    const SizedBox(height: 20.0),
                    _buildTextField(_fullnameController, 'Full Name', Icons.person, fullnameError),
                    const SizedBox(height: 20.0),
                    _buildTextField(_ageController, 'Age', Icons.confirmation_number, ageError),
                    const SizedBox(height: 20.0),
                    _buildTextField(_emailController, 'Email', Icons.email, emailError),
                    const SizedBox(height: 20.0),
                    _buildTextField(_nophoneController, 'No. Phone', Icons.phone, phoneError),
                    const SizedBox(height: 20.0),
                    _buildTextField(_addressController, 'Address', Icons.home, addressError),
                    const SizedBox(height: 20.0),
                    _buildDropdown(_selectedPosition, 'Select Position', Icons.category, positionError,
                        ['Student', 'Employee', 'Self-employed', 'Unemployed', 'Other'],
                            (selected) {
                          setState(() {
                            _selectedPosition = selected;
                          });
                        }
                    ),
                    const SizedBox(height: 20.0),
                    _buildDropdown(_selectedIncomeRange, 'Select Salary', Icons.money, incomeRangeError,
                        ['RM0-RM1500', 'RM1500-RM3000', 'RM3000-RM5000', '>RM5000'],
                            (selected) {
                          setState(() {
                            _selectedIncomeRange = selected;
                          });
                        }
                    ),
                    const SizedBox(height: 20.0),
                    _buildDropdown(_selectedMarriedStatus, 'Marital Status', Icons.manage_accounts_rounded, maritalStatusError,
                        ['Single', 'Married'],
                            (selected) {
                          setState(() {
                            _selectedMarriedStatus = selected;
                          });
                        }
                    ),
                    const SizedBox(height: 20.0),
                    _buildTextField(_passwordController, 'Password', Icons.lock, passwordError, obscureText: true),
                    const SizedBox(height: 20.0),
                    _buildTextField(_confirmpasswordController, 'Confirm Password', Icons.lock, confirmPasswordError, obscureText: true),
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

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, String? errorText, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorText: errorText,
      ),
    );
  }

  Widget _buildDropdown(String? currentValue, String hintText, IconData icon, String? errorText, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorText: errorText,
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: (selected) {
        onChanged(selected);
      },
    );
  }

}
