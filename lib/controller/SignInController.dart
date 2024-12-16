import 'package:workshop2dev/dbConnection/dbConnection.dart';

class AuthController {
  final DatabaseConnection dbConnection = DatabaseConnection();

  Future<String> signUp(String email, String username, String password, String age,String noIc ,String address,) async {
    await dbConnection.connectToDatabase();

    try {
      // Insert new user into the 'register' table
      String query =
          'INSERT INTO register (email, username, password) VALUES (@email, @username, @password)';
      await dbConnection.connection.query(
        query,
        substitutionValues: {
          'email': email,
          'username': username,
          'password': password, // Hash password in production

        },
      );
      return "Sign up successful";
    } catch (e) {
      return "Error signing up: $e";
    } finally {
      dbConnection.closeConnection();
    }
  }

  Future<String> login(String username, String password) async {
    await dbConnection.connectToDatabase();

    try {
      // Validate the user credentials
      String query =
          'SELECT * FROM register WHERE username = @username AND password = @password';
      final results = await dbConnection.connection.query(
        query,
        substitutionValues: {
          'username': username,
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
