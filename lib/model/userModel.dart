class User {
  final String userIC;
  final String fullname;
  final int age;
  final String email;
  final String phoneNumber;
  final String address;
  final String userCategory;
  final String incomeRange;
  final String marriageStatus;
  final String password;

  // Constructor
  User({
    required this.userIC,
    required this.fullname,
    required this.age,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.userCategory,
    required this.incomeRange,
    required this.marriageStatus,
    required this.password,
  });

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
  password: $password
}''';
  }
}
