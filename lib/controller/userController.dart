import 'package:workshop2dev/dbConnection/dbConnection.dart';
import '../model/userModel.dart';

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

  Future<String> updateUser(User user) async {
    await dbConnection.connectToDatabase();

    try {
      String query = '''
      UPDATE users
      SET fullname = @fullname,
          age = @age,
          email = @email,
          phonenumber = @phonenumber,
          address = @address,
          user_category = @user_category,
          income_range = @income_range,
          marriage_status = @marriage_status
      WHERE user_ic = @user_ic
      ''';

      await dbConnection.connection.query(
        query,
        substitutionValues: {
          'user_ic': user.userIC,
          'fullname': user.fullname,
          'age': user.age,
          'email': user.email,
          'phonenumber': user.phoneNumber,
          'address': user.address,
          'user_category': user.userCategory,
          'income_range': user.incomeRange,
          'marriage_status': user.marriageStatus,
        },
      );

      return "User details updated successfully";
    } catch (e) {
      return "Error updating user: $e";
    } finally {
      dbConnection.closeConnection();
    }
  }


  Future<User?> login(String noIc, String password) async {
    await dbConnection.connectToDatabase(); // Connect to database

    try {
      // Query to validate user credentials and fetch user data
      String query = '''
      SELECT * FROM users
      WHERE user_ic = @user_ic AND password = @password
    ''';

      final results = await dbConnection.connection.query(
        query,
        substitutionValues: {
          'user_ic': noIc,
          'password': password, // Note: Hash password comparison in production
        },
      );

      if (results.isNotEmpty) {
        // Map the query results to the User model
        var row = results[0];
        User user = User(
          userIC: row[0] as String, // Assuming column order matches the model
          fullname: row[1] as String,
          age: int.parse(row[2].toString()), // Ensure conversion to int
          email: row[3] as String,
          phoneNumber: row[4] as String,
          address: row[5] as String,
          userCategory: row[6] as String,
          incomeRange: row[7] as String,
          marriageStatus: row[8] as String,
          password: row[9] as String,
        );

        print("Mapped User Model: ${user.toString()}"); // Debug: Show mapped user model
        return user; // Return the populated User object
      } else {
        return null; // Return null if no match found
      }
    } catch (e) {
      print("Error logging in: $e");
      return null; // Return null in case of an error
    } finally {
      dbConnection.closeConnection(); // Close database connection
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
