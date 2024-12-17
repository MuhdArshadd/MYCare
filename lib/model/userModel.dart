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
    required this.password
  });

  // Method to convert a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'userIC': userIC,
      'fullname': fullname,
      'age': age,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'userCategory': userCategory,
      'incomeRange': incomeRange,
      'marriageStatus': marriageStatus,
      'password': password
    };
  }

  // // Optional: Method to convert a Map to a User object (from database, etc.)
  // factory User.fromMap(Map<String, dynamic> map) {
  //   return User(
  //     userIC: map['userIC'] ?? '',
  //     fullname: map['fullname'] ?? '',
  //     age: map['age'] ?? 0,
  //     email: map['email'] ?? '',
  //     phoneNumber: map['phoneNumber'] ?? '',
  //     address: map['address'] ?? '',
  //     userCategory: map['userCategory'] ?? '',
  //     incomeRange: map['incomeRange'] ?? '',
  //     marriageStatus: map['marriageStatus'] ?? '',
  //     password: map['password'] ?? '',
  //   );
  // }

}
