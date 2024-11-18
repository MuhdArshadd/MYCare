class User {
  final String email;
  final String username;
  final String password;
  final String confirmpassword;

  User({required this.email, required this.username, required this.password,required this.confirmpassword});

  Map<String, String> toMap() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'confirmpassword' : confirmpassword,// Hash password in production
    };
  }
}
