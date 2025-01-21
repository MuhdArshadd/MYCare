import 'dart:typed_data';

class User {
  String _userIC;
  String _fullname;
  int _age;
  String _email;
  String _phoneNumber;
  String _address;
  String _userCategory;
  String _incomeRange;
  String _marriageStatus;
  String _password;
  Uint8List? _profileImage;  // Corrected declaration

  // Constructor
  User({
    required String userIC,
    required String fullname,
    required int age,
    required String email,
    required String phoneNumber,
    required String address,
    required String userCategory,
    required String incomeRange,
    required String marriageStatus,
    required String password,
    Uint8List? profileImage, // Make nullable and optional in parameters
  })  : _userIC = userIC,
        _fullname = fullname,
        _age = age,
        _email = email,
        _phoneNumber = phoneNumber,
        _address = address,
        _userCategory = userCategory,
        _incomeRange = incomeRange,
        _marriageStatus = marriageStatus,
        _password = password,
        _profileImage = profileImage; // Corrected placement in constructor

  // Getters and setters
  String get userIC => _userIC;

  String get fullname => _fullname;
  set fullname(String value) => _fullname = value;

  int get age => _age;
  set age(int value) => _age = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) => _phoneNumber = value;

  String get address => _address;
  set address(String value) => _address = value;

  String get userCategory => _userCategory;
  set userCategory(String value) => _userCategory = value;

  String get incomeRange => _incomeRange;
  set incomeRange(String value) => _incomeRange = value;

  String get marriageStatus => _marriageStatus;
  set marriageStatus(String value) => _marriageStatus = value;

  String get password => _password;
  set password(String value) => _password = value;

  Uint8List? get profileImage => _profileImage;  // Fixed getter reference
  set profileImage(Uint8List? value) => _profileImage = value;

  // Override toString method for debugging
  @override
  String toString() {
    return '''
User {
  userIC: $userIC,
  fullname: $fullname,
  age: $age,
  email: $email,
  phoneNumber: $phoneNumber,
  address: $address,
  userCategory: $userCategory,
  incomeRange: $incomeRange,
  marriageStatus: $marriageStatus,
  password: $password,
  profileImage: $profileImage
}''';
  }
}
