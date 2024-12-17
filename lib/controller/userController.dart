import 'package:workshop2dev/dbConnection/dbConnection.dart';

class UserController {
  final DatabaseConnection dbConnection = DatabaseConnection();

  Future<String> signUp(String noIc, String fullname, String age,String email,String phoneNumber,String address,String userCategory,String incomeRange,String marriageStatus,String password) async {
    await dbConnection.connectToDatabase();

    try {
      // Insert new user into the 'register' table
      String query =
          'INSERT INTO users (user_ic,fullname,age,email,phonenumber, address,user_category,income_range,marriage_status,password) '
          'VALUES (@user_ic, @fullname, @age,@email,@phonenumber,@address,@user_category,@income_range,@marriage_status,@password)';

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
          'password':password
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

  Future<String> resetPass(String email, String newPassword) async {
    await dbConnection.connectToDatabase();

    try {
      // SQL query to update password
      String query = "UPDATE users SET password = @password WHERE email = @email";

      // Execute query with email and newPassword as substitution values
      await dbConnection.connection.query(
        query,
        substitutionValues: {
          'email': email,       // Use the passed email
          'password': newPassword,  // Use the passed new password
        },
      );

      return "Password update successful";
    } catch (e) {
      return "Error updating password: $e";
    } finally {
      dbConnection.closeConnection();
    }
  }

}
