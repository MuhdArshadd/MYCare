import 'package:workshop2dev/dbConnection/dbConnection.dart';

class AuthController {
  final DatabaseConnection dbConnection = DatabaseConnection();

  Future<String> signUp(String noIc, String fullname, String age,String email,String phoneNumber,String address
      ,String userCategory,String incomeRange,String marriageStatus,String password,String confirmPass) async {
    await dbConnection.connectToDatabase();

    try {
      // Insert new user into the 'register' table
      String query =
          'INSERT INTO users (user_ic,fullname,age,email,phonenumber,'
          'address,user_category,income_range,marriage_status,password,confirmpass) VALUES (@user_ic, @fullname, @age,@email,@phonenumber,@address,@user_category,@income_range,@marriage_status,@password,@confirmpass)';
      await dbConnection.connection.query(
        query,
        substitutionValues: {
          'user_ic': noIc,
          'fullname': fullname,
          'age': age,
          'email': email,
          'phonenumber': phoneNumber,
          'address': address,
          'user_category': userCategory ?? 'general',
          'income_range': incomeRange ?? 0.0,
          'marriage_status': marriageStatus ?? 'unknown',
          'password':password,
          'confirmpass':confirmPass
        },
      );
      return "Sign up successful";
    } catch (e) {
      return "Error signing up: $e";
    } finally {
      dbConnection.closeConnection();
    }
  }

  Future<String> login(String noIc, String password) async {
    await dbConnection.connectToDatabase();

    try {
      // Validate the user credentials
      String query =
          'SELECT * FROM users WHERE user_ic = @user_ic AND password = @password';
      final results = await dbConnection.connection.query(
        query,
        substitutionValues: {
          'user_ic': noIc,
          'password': password, // Hash password comparison in production
        },
      );

      if (results.isNotEmpty) {
        return "Login successful";
      } else {
        return "Invalid email or password";
      }
    } catch (e) {
      return "Error logging in: $e";
    } finally {
      dbConnection.closeConnection();
    }
  }
}
