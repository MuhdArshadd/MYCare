// dbConnection.dart
import 'package:postgres/postgres.dart';

class DatabaseConnection {
  late PostgreSQLConnection connection;

  Future<String> connectToDatabase() async {
    connection = PostgreSQLConnection(
      'workshop2gp7.postgres.database.azure.com', // host
      5432, // port
      'postgres', // database name
      username: 'postgres', // username
      password: 'workshop2#', // latest password
      useSSL: true, // SSL enabled
    );

    try {
      await connection.open();
      return "Connected to database";
    } catch (e) {
      return "Failed to connect to database: $e";
    }
  }

  void closeConnection() {
    connection.close();
  }
}
